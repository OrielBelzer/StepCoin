//
//  ViewController.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 21/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation
import Haneke

let arViewController = ARViewController()
/*  
 
 The issue happens I believe when there are no coins available at all for the collect coin view to tryand parse. 
 
 */
class CollectCoinViewController: UIViewController, ARDataSource, UITabBarDelegate, CLLocationManagerDelegate
{
    let cache = Shared.dataCache

    override func viewDidLoad()
    {
        super.viewDidLoad()
        showARViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!arViewController.didCloseCamera) {
            showARViewController()
        } else {
            arViewController.didCloseCamera = false
            self.performSegue(withIdentifier: "CollectCoinToTabController", sender: self)
        }
    }
    
    /// Creates random annotations around predefined center point and presents ARViewController modally
    func showARViewController()
    {
        // Check if device has hardware needed for augmented reality
        let result = ARViewController.createCaptureSession()
        if result.error != nil
        {
            let message = result.error?.userInfo["description"] as? String
            let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
            alertView.show()
            return
        }
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation

        currentLocation = locManager.location!
        
        NSLog("lat " + String(currentLocation.coordinate.latitude))
        NSLog("long " + String(currentLocation.coordinate.longitude))
        
        let lat = currentLocation.coordinate.latitude // 37.241681
        let lon = currentLocation.coordinate.longitude // -121.884804
        let delta = 0.05
        let count = 2
        let coinsAnnotations = self.getCoinsAnnotations(centerLatitude: lat, centerLongitude: lon, delta: delta, count: count)
   
        // Present ARViewController
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        //arViewController.setAnnotations(coinsAnnotations)
        arViewController.uiOptions.debugEnabled = false
        arViewController.uiOptions.closeButtonEnabled = true
        //arViewController.interfaceOrientationMask = .landscape
        arViewController.onDidFailToFindLocation =
        {
            [weak self, weak arViewController] elapsedSeconds, acquiredLocationBefore in
                
            self?.handleLocationFailure(elapsedSeconds: elapsedSeconds, acquiredLocationBefore: acquiredLocationBefore, arViewController: arViewController)
        }
        self.present(arViewController, animated: true, completion: nil)
    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView
    {
        // Annotation views should be lightweight views, try to avoid xibs and autolayout all together.
        let annotationView = CoinAnnotationView()
        annotationView.coin = viewForAnnotation.coin
        annotationView.frame = CGRect(x: 0,y: 0,width: 150,height: 50)
        return annotationView;
    }
    
    fileprivate func getCoinsAnnotations(centerLatitude: Double, centerLongitude: Double, delta: Double, count: Int) -> Array<ARAnnotation>
    {
        var annotations: [ARAnnotation] = []
        
        let userCurrentCoordinates = CLLocation(latitude: centerLatitude, longitude: centerLongitude)
        
        CoinsController().reloadCoinsFromServerWithinCoordinatesRange(longitude: String(userCurrentCoordinates.coordinate.longitude), latitude: String(userCurrentCoordinates.coordinate.latitude), forceReload: true) { (responseObject:[AnyObject], error:String) in
            
            Shared.dataCache.fetch(key: "coins").onSuccess { data in
                if let coins = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Coin2] {
                    for coin in coins {
                        let annotation = ARAnnotation()
                        let coinCoordinates = CLLocation(latitude: Double((coin.location?.latitude)!)!, longitude: Double((coin.location?.longitude)!)!)
                        NSLog("Distance between current location to coin location is " + String(userCurrentCoordinates.distance(from: coinCoordinates)))
                        if (userCurrentCoordinates.distance(from: coinCoordinates) <= 20) //Coins is within 20 meters away from user's current location
                        {
                            annotation.coin = coin
                            annotation.location = coinCoordinates
                            annotations.append(annotation)
                        }
                    }
                }
                arViewController.setAnnotations(annotations)
            }
        }
        
        return annotations
    }

    
    func handleLocationFailure(elapsedSeconds: TimeInterval, acquiredLocationBefore: Bool, arViewController: ARViewController?)
    {
        guard let arViewController = arViewController else { return }
        
        NSLog("Failed to find location after: \(elapsedSeconds) seconds, acquiredLocationBefore: \(acquiredLocationBefore)")
        
        // Example of handling location failure
        if elapsedSeconds >= 20 && !acquiredLocationBefore
        {
            // Stopped bcs we don't want multiple alerts
            arViewController.trackingManager.stopTracking()
            
            let alert = UIAlertController(title: "Problems", message: "Cannot find location, use Wi-Fi if possible!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Close", style: .cancel)
            {
                (action) in
                
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            
            self.presentedViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
