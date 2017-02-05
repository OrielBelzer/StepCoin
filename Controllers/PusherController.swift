//
//  PusherController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 1/13/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
// 
//
//import Foundation
//import PusherSwift
//
//let options = PusherClientOptions(
//    host: .cluster("eu")
//)
//
//let pusher = Pusher(
//    key: "1bd785901a27dba35033",
//    options: options
//)
//
//// subscribe to channel and bind to event
//let channel = pusher.subscribe("my-channel")
//
//let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
//    if let data = data as? [String : AnyObject] {
//        if let message = data["message"] as? String {
//            print(message)
//        }
//    }
//})
//
//pusher.connect()
//
//class PusherController
//{
//   
//    
//}
//
