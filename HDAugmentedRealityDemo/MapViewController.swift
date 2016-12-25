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


class MapViewController: UIViewController, MGLMapViewDelegate
{
    @IBOutlet var mapView: MGLMapView!
    var coinsController = CoinsController()
    let defaults = UserDefaults.standard
    var counter = 0
    let cache = Shared.dataCache

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.userTrackingMode = .follow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addCoinsToMap()
//        for coin in coinsController.coins {
//            let point = MGLPointAnnotation()
//            point.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
//            point.coordinate = CLLocationCoordinate2D(latitude: Double(coin.latitude)!, longitude: Double(coin.longitude)!)
//            point.title = coin.worth
//            mapView.addAnnotation(point)
//        }
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        /*      
                    TO-DO
            This is where I should get coins based on the
            zoom of the map. The below has the points of the map.
         
 
        print("---------------------------------")
        print(mapView.visibleCoordinateBounds.ne.latitude)
        print(mapView.visibleCoordinateBounds.ne.longitude)
        print(mapView.visibleCoordinateBounds.sw.latitude)
        print(mapView.visibleCoordinateBounds.sw.longitude)
        print("---------------------------------")
         
        */
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        print(counter)
        counter += 1
        print(userLocation?.coordinate.latitude)
        print(userLocation?.coordinate.longitude)
        
        coinsController.reloadCoinsFromServer(longitude: (userLocation?.coordinate.longitude.description)!, latitude: (userLocation?.coordinate.latitude.description)!) { (responseObject:[AnyObject], error:String) in
                self.addCoinsToMap()
        }
        
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: "CoinImage")
        
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

    private func addCoinsToMap() {
        Shared.dataCache.fetch(key: "coins").onSuccess { data in
            if (self.mapView.annotations != nil) {
                self.mapView.removeAnnotations(self.mapView.annotations!)
            }
            
            if let coins = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Coin2] {
                for coin in coins {
                    let point = MGLPointAnnotation()
                    point.coordinate = CLLocationCoordinate2D(latitude: Double((coin.location?.latitude)!)!, longitude: Double((coin.location?.longitude)!)!)
                    point.title = "$"+coin.value! + " at"
                    self.mapView.addAnnotation(point)
                }
            }
        }
    }
    
}
