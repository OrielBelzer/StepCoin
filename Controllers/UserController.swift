//
//  UserController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/23/16.
//

import Haneke
import SwiftyJSON

open class UserController
{
    let cache = Shared.dataCache
    let defaults = UserDefaults.standard

    func calcUserQuantities() {
        var sumOfUserCoinsValue = 0.0
        var uniqueStoreIDs = Set<Int>()
        
        cache.fetch(key: "user").onSuccess { data in
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                for coin in (user.coins)! {
                    if !uniqueStoreIDs.contains(coin.storeId!) { uniqueStoreIDs.insert(coin.storeId!) }
                    sumOfUserCoinsValue += Double(coin.value!)!
                }
                
                self.defaults.set(user.coins?.count, forKey: "userNumberOfCoins")
                self.defaults.set(sumOfUserCoinsValue, forKey: "userSumOfCoinsValue")
                self.defaults.set(uniqueStoreIDs.count, forKey: "userSumOfCoinsStores")
                self.defaults.synchronize()
            }
        }
    }
    
    func sendLocationToServer(userId: String, latitude: String, longitude: String) {
        ConnectionController.sharedInstance.sendLocationToServer(userId: userId, longitude: longitude, latitude: latitude)   { (responseObject:SwiftyJSON.JSON, error:String) in
            if (error == "") {
            } else {
                print(error)
            }
        }
    }
}

