//
//  ConnectionController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/21/16.
//

import Alamofire
import SwiftyJSON

typealias ServiceResponse = (JSON, String) -> Void


class ConnectionController
{
    let stepCoinBaseURL = "http://stepcoin.co:8888"

    class var sharedInstance:ConnectionController {
        struct Singleton {
            static let instance = ConnectionController()
        }
        return Singleton.instance
    }
    
    func registerUser(emailAddress: String, password: String, onCompletion: @escaping ServiceResponse) -> Void {
        let params = ["email": emailAddress, "password": password]
        
        Alamofire.request(stepCoinBaseURL+"/registerUser", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                onCompletion(json, "")
            case .failure(let error):
                onCompletion(nil, error.localizedDescription)
                print(error)
            }
        }
    }

}

