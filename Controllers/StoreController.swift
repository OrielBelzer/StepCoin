//
//  StoreController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/25/16.
//  Copyright © 2016 Danijel Huis. All rights reserved.
// 

import Haneke

open class StoreController
{
    let cache = Shared.dataCache
    let defaults = UserDefaults.standard
    
    
    func getStoresForCoins(coinsToGetStoresFor: [Coin2]) {
        Shared.dataCache.fetch(key: "stores").onSuccess { data in
            var userCoinsStores: [Store] = []
            
            if let stores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Store] {
                userCoinsStores = stores
            }
            for userCoin in coinsToGetStoresFor {
                ConnectionController.sharedInstance.getStore(storeId: String(describing: userCoin.storeId!))  { (responseObject1:[AnyObject], error:String) in
                    if (error == "") {
                        if !(userCoinsStores.contains((responseObject1[0] as? Store)!)) {
                            userCoinsStores.append((responseObject1[0] as? Store)!)
                            self.cache.remove(key: "stores")
                            self.cache.set(value: NSKeyedArchiver.archivedData(withRootObject: userCoinsStores), key: "stores")
                        }
                    } else {
                        print(error)
                    }
                }
            }
        }
        
        Shared.dataCache.fetch(key: "stores").onFailure { data in
            var userCoinsStores: [Store] = []
            
            for userCoin in coinsToGetStoresFor {
                ConnectionController.sharedInstance.getStore(storeId: String(describing: userCoin.storeId!))  { (responseObject1:[AnyObject], error:String) in
                    if (error == "") {
                        if !(userCoinsStores.contains((responseObject1[0] as? Store)!)) {
                            userCoinsStores.append((responseObject1[0] as? Store)!)
                            self.cache.remove(key: "stores")
                            self.cache.set(value: NSKeyedArchiver.archivedData(withRootObject: userCoinsStores), key: "stores")
                        }
                    } else {
                        print(error)
                    }
                }
            }
        }
    }
}

