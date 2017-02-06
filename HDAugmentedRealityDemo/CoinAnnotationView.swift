//
//  TestAnnotationView.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 30/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import CoreLocation

open class CoinAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    open var titleLabel: UILabel?
    open var infoButton: UIButton?
    open var imageView: UIImageView?
    open var coinIcon = ""
    open var coin: Coin2?
    open var collected = false

    let defaults = UserDefaults.standard


    override open func didMoveToSuperview()
    {
        super.didMoveToSuperview()
        if self.titleLabel == nil
        {
            self.loadUi()
        }
    }
    
    func loadUi()
    {
        //Add Coing Icon
        if (coinIcon.isEmpty) {
            self.coinIcon = "CollectCoinImage"
        }
        let image = UIImage(named: self.coinIcon)
        self.imageView = UIImageView(image: image!)
        self.addSubview(imageView!)
        
        
        // Title label
        self.titleLabel?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        self.addSubview(label)
        self.titleLabel = label
        
        /*
        // Info button
        self.infoButton?.removeFromSuperview()
        let button = UIButton(type: UIButtonType.detailDisclosure)
        button.isUserInteractionEnabled = false   // Whole view will be tappable, using it for appearance
        self.addSubview(button)
        self.infoButton = button
        */
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CoinAnnotationView.collectCoin))
        self.addGestureRecognizer(tapGesture)
        
        /*
        // Other
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = 5
        */
        if self.annotation != nil
        {
            self.bindUi()
        }
    }
    
    func layoutUi()
    {
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        
        self.titleLabel?.frame = CGRect(x: 10, y: 0, width: self.frame.size.width - buttonWidth - 5, height: self.frame.size.height);
        self.infoButton?.frame = CGRect(x: self.frame.size.width - buttonWidth, y: self.frame.size.height/2 - buttonHeight/2, width: buttonWidth, height: buttonHeight);
    }
    
    // This method is called whenever distance/azimuth is set
    override open func bindUi()
    {
        if let annotation = self.annotation, let title = annotation.title
        {
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            
            let text = String(format: "%@\nAZ: %.0f°\nDST: %@", title, annotation.azimuth, distance)
            self.titleLabel?.text = text
        }
    }
     
    open override func layoutSubviews()
    {
        super.layoutSubviews()
        self.layoutUi()
    }
    
    open func collectCoin()
    {
        if (self.annotation != nil && !self.collected)
        {
            print("Collecting coin")
            self.collected = true
            ConnectionController.sharedInstance.collectCoin(userId: Int((defaults.value(forKey: "userId") as? String)!)! , coinId: (coin?.id)!)  { (responseObject:SwiftyJSON.JSON, error:String) in
                if (error == "") {
                    Shared.dataCache.fetch(key: "stores").onSuccess { data in
                        if let stores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Store] {
                            for store in stores {
                                if store.id == self.coin?.storeId {
                                    let message = "Congrats! You just collected a coin for " + store.name! + ", worth $" + (self.coin?.value)!
                                    let alertView = UIAlertView(title: "Coin Collected", message: message, delegate: nil, cancelButtonTitle: "OK")
                                    alertView.show()
                                    self.imageView?.removeFromSuperview()
                                    break
                                }
                            }
                        }
                    }
                    
                    let locManager = CLLocationManager()
                    var location: CLLocation
                    
                    location = locManager.location!
                    
                    NSLog("lat " + String(location.coordinate.latitude))
                    NSLog("long " + String(location.coordinate.longitude))
                    
                    CoinsController().reloadCoinsFromServerWithinCoordinatesRange(longitude: String(location.coordinate.longitude), latitude: String(location.coordinate.latitude), forceReload: true) { (responseObject:[AnyObject], error:String) in
                    }
                    
                } else {
                    print(error)
                    self.collected = false
                }
            }
        }
    }


}
