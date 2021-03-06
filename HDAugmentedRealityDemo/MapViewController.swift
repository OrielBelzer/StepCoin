//
//  MapViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/07/16.
//  Copyright (c) 2016 StepCoin. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import Haneke
import SwiftyJSON


class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate
{
    var updateTimer: Timer?
    @IBOutlet var mapView: MGLMapView!
    var coinsController = CoinsController()
    let defaults = UserDefaults.standard
    let cache = Shared.dataCache
    var counter = 0
    let locManager = CLLocationManager()
    var lastTimeLocationWasSentToServer = Date()
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers

    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        locManager.delegate = self

      //  if (defaults.bool(forKey:"shouldReloadMapDelegateAgain")) 

        
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
            mapView.addGestureRecognizer(singleTap)
        
            sendLocationToServer()
            defaults.set(false, forKey: "shouldReloadMapDelegateAgain")
       // }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //WORK AROUND - NEED TO FIX IT AT SOME POINT 
        mapView.delegate = nil
        //mapView.removeFromSuperview()
       // self.dismiss(animated: false, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCoinsToMap(swLongitude: String(mapView.visibleCoordinateBounds.sw.longitude), swLatitude: String(mapView.visibleCoordinateBounds.sw.latitude), neLongitude: String(mapView.visibleCoordinateBounds.ne.longitude), neLatitude: String(mapView.visibleCoordinateBounds.ne.latitude))
        
        //WORK AROUND - NEED TO FIX IT AT SOME POINT
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
        /* Get configuration from server */
        
        ConnectionController.sharedInstance.getConfiguration(userId: (defaults.value(forKey: "userId") as! String))   { (responseObject:SwiftyJSON.JSON, error:String) in
            if (error == "") {
                self.defaults.set(responseObject["collect_coins_visability_distance"].stringValue, forKey: "visabilityDistance")
                self.defaults.set(responseObject["desiredAccuracy"].stringValue, forKey: "desiredAccuracy")
                
                switch (self.defaults.value(forKey: "desiredAccuracy") as! String)
                {
                case "best":
                    self.desiredAccuracy = kCLLocationAccuracyBest
                case "ten":
                    self.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                case "hundreds":
                    self.desiredAccuracy = kCLLocationAccuracyHundredMeters
                case "kilometer":
                    self.desiredAccuracy = kCLLocationAccuracyKilometer
                case "threeKilomoters":
                    self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                default:
                    self.desiredAccuracy = kCLLocationAccuracyHundredMeters
                }
                self.sendLocationToServer()
            } else {
                print(error)
              //  self.desiredAccuracy = kCLLocationAccuracyHundredMeters
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        loadCoinsToMap(swLongitude: String(mapView.visibleCoordinateBounds.sw.longitude), swLatitude: String(mapView.visibleCoordinateBounds.sw.latitude), neLongitude: String(mapView.visibleCoordinateBounds.ne.longitude), neLatitude: String(mapView.visibleCoordinateBounds.ne.latitude))

        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                if (self.defaults.value(forKey: "gotFirstFreeCoin") == nil) {
                    let locManager = CLLocationManager()
                    locManager.requestWhenInUseAuthorization()
                    var currentLocation: CLLocation
                    currentLocation = locManager.location!
                    
                    let lat = currentLocation.coordinate.latitude // 37.241681
                    let lon = currentLocation.coordinate.longitude // -121.884804
                    
                    ConnectionController.sharedInstance.addCoin(longitude: String(lon), latitude: String(lat))  { (responseObject:SwiftyJSON.JSON, error:String) in
                        if (error == "") {
                        } else {
                            print(error)
                        }
                    }
                    
                    defaults.set(true, forKey: "gotFirstFreeCoin")
                } else {
                    //Nothing - user should not get another coin
                }
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func loadCoinsToMap(swLongitude: String, swLatitude: String, neLongitude: String, neLatitude: String) {
        print("---------------------------------")
        print(mapView.visibleCoordinateBounds.ne.latitude)
        print(mapView.visibleCoordinateBounds.ne.longitude)
        print(mapView.visibleCoordinateBounds.sw.latitude)
        print(mapView.visibleCoordinateBounds.sw.longitude)
        print("---------------------------------")
        
        coinsController.reloadCoinsFromServerBasedOnZoom(userId: self.defaults.value(forKey: "userId") as! String, swLongitude: swLongitude, swLatitude: swLatitude, neLongitude: neLongitude, neLatitude: neLatitude) { (responseObject:[AnyObject], error:String) in
            if (error == "") {
                StoreController().getStoresForCoins(coinsToGetStoresFor: (responseObject as? [Coin2])!)
                self.addCoinsToMap(coinsToAddToMap: (responseObject as? [Coin2])!)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {

    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "CoinImage")
        
        /* TODO - 
                1. To see if I can put the logo of the business as a coin instaed of the generic photo
                2. See if I can group annotations in case there is more than 1 at the exact same location
        */
        if annotationImage == nil {
            var image = UIImage(named: "CoinImage")!
            image = image.withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "CoinImage")
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    private func addCoinsToMap(coinsToAddToMap: [Coin2]) {
        if (self.mapView.annotations != nil) {
            self.mapView.removeAnnotations(self.mapView.annotations!)
        }
        
        for coin in coinsToAddToMap {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: Double((coin.location?.latitude)!)!, longitude: Double((coin.location?.longitude)!)!)
            Shared.dataCache.fetch(key: "stores").onSuccess { data in
                if let stores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Store] {
                    for store in stores {
                        if store.id == coin.storeId {
                            point.title = "$"+coin.value! + " at " + store.name!
                            self.mapView.addAnnotation(point)
                            break
                        }
                    }
                }
            }
        }
    }
    
    func handleSingleTap(tap: UITapGestureRecognizer) {
        if (self.defaults.value(forKey: "debugMode") != nil) {
            if (self.defaults.bool(forKey: "debugMode")) {
                let location: CLLocationCoordinate2D = mapView.convert(tap.location(in: mapView), toCoordinateFrom: mapView)
                print("You tapped at: \(location.latitude), \(location.longitude)")
        
                ConnectionController.sharedInstance.addCoin(longitude: String(location.longitude), latitude: String(location.latitude))  { (responseObject:SwiftyJSON.JSON, error:String) in
                        if (error == "") {
                        } else {
                            print(error)
                    }
                }
            }
        }
    }
     
    func sendLocationToServer() {
        locManager.requestAlwaysAuthorization()
        //var currentLocation: CLLocation
        let currentLocation = locManager.location
        if (currentLocation != nil) {
            // currentLocation = try locManager.location!
            locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locManager.distanceFilter = 100
            locManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        counter = counter + 1
        print("in updated location " + String(counter))
        let currentDateTime = Date()
        
        if (minutesBetweenDates(startDate: lastTimeLocationWasSentToServer, endDate: currentDateTime) >= 1) {
            let location:CLLocation = locations[locations.count-1] as CLLocation
            
            UserController().sendLocationToServer(userId: defaults.value(forKey: "userId") as! String, latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude))
            lastTimeLocationWasSentToServer = currentDateTime
        }
    }
    
    func minutesBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.minute], from: startDate, to: endDate)
        return components.minute!
    }
}
