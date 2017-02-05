//
//  Coin.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/17/16.
//  Copyright © 2016 Danijel Huis. All rights reserved.
// 

import UIKit
import CoreLocation

open class Coin
{
    open var longitude: String
    open var latitude: String
    open var address: String
    open var type: String //1 Generic or 2 specific
    open var businessName: String //Relevant for type 2
    open var businessLogoLink: String
    open var worth: String
    
    
    init(longitude: String, latitude: String, address: String, type: String, businessName: String, businessLogoLink: String, worth: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.type = type
        self.businessName = businessName
        self.businessLogoLink = businessLogoLink
        self.worth = worth
    }
}
