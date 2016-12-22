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
    var coinsController = CoinsController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for coin in coinsController.coins {
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: Double(coin.latitude)!, longitude: Double(coin.longitude)!)
            point.title = coin.worth
            mapView.addAnnotation(point)
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

    
}
