//
//  ConnectionController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/21/16.
//

import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import Haneke
import OneSignal


typealias ServiceResponseJSON = (SwiftyJSON.JSON, String) -> Void
typealias ServiceResponseAnyObject = (AnyObject, String) -> Void
typealias ServiceResponseAnyObjectArray = ([AnyObject], String) -> Void


class ConnectionController
{
    //let stepCoinBaseURL = "http://stepcoin.ddns.net:8888"
    let stepCoinBaseURL = "https://stepcoin.co:8888"

    class var sharedInstance:ConnectionController {
        struct Singleton {
            static let instance = ConnectionController()
        }
        return Singleton.instance
    }
    
    func registerUser(emailAddress: String, password: String, onCompletion: @escaping ServiceResponseJSON) -> Void {
        let params = ["email": emailAddress, "password": password]
        
        Alamofire.request(stepCoinBaseURL+"/registerUser", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(JSON.null, error.localizedDescription)
                print(error)
            }
        }
    }
    
    func login(emailAddress: String, password: String, onCompletion: @escaping ServiceResponseJSON) -> Void {
        /*OneSignal.idsAvailable({ (userId, pushToken) in
            print("UserId:%@", userId)
            if (pushToken != nil) {
                print("pushToken:%@", pushToken)
            }
        })
        
        let params = ["email": emailAddress, "password": password, "notificationId": userId]
        */
        let params = ["email": emailAddress, "password": password]
        
        Alamofire.request(stepCoinBaseURL+"/users/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json["id"])
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(JSON.null, error.localizedDescription)
                print(error)
            }
        }
        
    }
    
    func getUser(userId: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        Alamofire.request(stepCoinBaseURL+"/users/"+userId).responseArray { (response: DataResponse<[User]>) in
            /* ERROR HERE - CANT SERIALIZE THE USER OBJECT ALL OF A SUDDEN */
            switch response.result {
            case .success(let value):
                let user = response.result.value
                
                let cache = Shared.dataCache
                cache.remove(key: "user")
                cache.set(value: NSKeyedArchiver.archivedData(withRootObject: user![0]), key: "user")
            
                onCompletion(user!, "")
            case .failure(let error):
                print(response.result.value)
                onCompletion([], error.localizedDescription)
                print(error)
            }
        }

    }
    
    func getStore(storeId: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        Alamofire.request(stepCoinBaseURL+"/stores/"+storeId).responseArray { (response: DataResponse<[Store]>) in
            switch response.result {
            case .success(let value):
                let store = response.result.value
                
                //let cache = Shared.dataCache
                //cache.remove(key: "user")
                //cache.set(value: NSKeyedArchiver.archivedData(withRootObject: user![0]), key: "user")
                
                onCompletion(store!, "")
            case .failure(let error):
                print(response.result.value)
                onCompletion([], error.localizedDescription)
                print(error)
            }
        }
        
    }
    
    func getCoinsBasedOnZoom(swLongitude: String, swLatitude: String,neLongitude: String, neLatitude: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        let params = ["sw.longitude": swLongitude, "sw.latitude": swLatitude, "ne.longitude": neLongitude, "ne.latitude": neLatitude]
        
        Alamofire.request(stepCoinBaseURL+"/coins", parameters: params).responseArray { (response: DataResponse<[Coin2]>) in
            switch response.result {
            case .success(let value):
                let coins = response.result.value
                
                if (coins?.count == 0) {
                    onCompletion([], "no coins in zoom")
                } else {
                    onCompletion(coins!, "")
                }
            case .failure(let error):
                onCompletion([], error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getCoins(longitude: String, latitude: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        let params = ["longitude": longitude, "latitude": latitude]
        
        Alamofire.request(stepCoinBaseURL+"/coins", parameters: params).responseArray { (response: DataResponse<[Coin2]>) in
            switch response.result {
            case .success(let value):
                let coins = response.result.value
                
                let cache = Shared.dataCache
                cache.remove(key: "coins")
                cache.set(value: NSKeyedArchiver.archivedData(withRootObject: coins!), key: "coins")

                if (coins?.count == 0) {
                    onCompletion([], "no coins")
                } else {
                    onCompletion(coins!, "")
                }
            case .failure(let error):
                print(response.result.value!)
                onCompletion([], error.localizedDescription)
                print(error)
            }
        }
    }
    
    func collectCoin(userId: Int, coinId: Int, onCompletion: @escaping ServiceResponseJSON) -> Void {
        let params = ["userId": String(userId), "coinId": String(coinId)]
        
        Alamofire.request(stepCoinBaseURL+"/coins/collect", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(response)
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(JSON.null, error.localizedDescription)
                print(error)
            }
        }
        
    }
    
    func addCoin(longitude: String, latitude: String, onCompletion: @escaping ServiceResponseJSON) -> Void {
        let params = ["longitude": longitude, "latitude": latitude]
        
        Alamofire.request(stepCoinBaseURL+"/coins", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json["id"])
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(JSON.null, error.localizedDescription)
                print(error)
            }
        }
    }
    
    func sendLocationToServer(userId: String, longitude: String, latitude: String, onCompletion: @escaping ServiceResponseJSON) -> Void {
        let params = ["longitude": longitude, "latitude": latitude]
        
        Alamofire.request(stepCoinBaseURL+"/users/"+userId, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(JSON.null, error.localizedDescription)
                print(error)
            }
        }
    }


}

