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


class MapViewController: UIViewController, MGLMapViewDelegate
{
 
    @IBOutlet var mapView: MGLMapView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        mapView.delegate = self
//        
//        mapView.userTrackingMode = .follow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let profileView = ProfileViewController() //Needed in order to access the coins data which we store in the profile view for now
//        profileView.convertCoinsCoordinatesToAddress() //Need to run it just in case the user didn't changed a screen to the profile before going to the map
//        
//        for coin in profileView.coins {
//            let point = MGLPointAnnotation()
//            point.coordinate = CLLocationCoordinate2D(latitude: Double(coin.0)!, longitude: Double(coin.1)!)
//            point.title = coin.5 //Coin's worth
//            point.subtitle = coin.3 //Coin's address
//            
//            mapView.addAnnotation(point)
//            
//            //TODO -
//            //  Cusomize the annotation icon to a coin annotaion
//            //  Try to focus on the user location when loading the map
//        }

        
    }

    
}
