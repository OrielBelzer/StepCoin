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
        mapView.delegate = self
        
        mapView.userTrackingMode = .follow
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 45.52258, longitude: -122.6732)
        point.title = "Voodoo Doughnut"
        point.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        
        mapView.addAnnotation(point)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
}
