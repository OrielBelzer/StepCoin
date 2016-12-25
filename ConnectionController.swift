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

typealias ServiceResponseJSON = (SwiftyJSON.JSON, String) -> Void
typealias ServiceResponseAnyObject = (AnyObject, String) -> Void
typealias ServiceResponseAnyObjectArray = ([AnyObject], String) -> Void


class ConnectionController
{
    let stepCoinBaseURL = "http://77.126.47.21:8888"
    //let stepCoinBaseURL = "http://stepcoin.co:8888"

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
    
    func getCoins(longitude: String, latitude: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        let params = ["longitude": longitude, "latitude": latitude]
        
        Alamofire.request(stepCoinBaseURL+"/coins", parameters: params).responseArray { (response: DataResponse<[Coin2]>) in
            switch response.result {
            case .success(let value):
                let coins = response.result.value
                print(coins?[0].id)
                
                let cache = Shared.dataCache
                cache.remove(key: "coins")
                cache.set(value: NSKeyedArchiver.archivedData(withRootObject: coins!), key: "coins")

                onCompletion(coins!, "")
            case .failure(let error):
                print(response.result.value!)
                onCompletion([], error.localizedDescription)
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

}

