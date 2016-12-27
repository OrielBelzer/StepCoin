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
    let cache = Shared.dataCache

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.userTrackingMode = .follow

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCoinsToMap(swLongitude: String(mapView.visibleCoordinateBounds.sw.longitude), swLatitude: String(mapView.visibleCoordinateBounds.sw.latitude), neLongitude: String(mapView.visibleCoordinateBounds.ne.longitude), neLatitude: String(mapView.visibleCoordinateBounds.ne.latitude))
    }
    
    func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
        loadCoinsToMap(swLongitude: String(mapView.visibleCoordinateBounds.sw.longitude), swLatitude: String(mapView.visibleCoordinateBounds.sw.latitude), neLongitude: String(mapView.visibleCoordinateBounds.ne.longitude), neLatitude: String(mapView.visibleCoordinateBounds.ne.latitude))
    }
    
    func loadCoinsToMap(swLongitude: String, swLatitude: String, neLongitude: String, neLatitude: String) {
        print("---------------------------------")
        print(mapView.visibleCoordinateBounds.ne.latitude)
        print(mapView.visibleCoordinateBounds.ne.longitude)
        print(mapView.visibleCoordinateBounds.sw.latitude)
        print(mapView.visibleCoordinateBounds.sw.longitude)
        print("---------------------------------")
        
        coinsController.reloadCoinsFromServerBasedOnZoom(swLongitude: swLongitude, swLatitude: swLatitude, neLongitude: neLongitude, neLatitude: neLatitude) { (responseObject:[AnyObject], error:String) in
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
    
}
