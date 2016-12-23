//
//  User.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/22/16.
//

import ObjectMapper

class User: Mappable {
    var id: Int?
    var email: String?
    var password: String?
    var phoneNumber: String?
    var credits: String?
    var createTime: String?
    var coins: [Coin2]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        email           <- map["email"]
        password        <- map["password"]
        phoneNumber     <- map["phoneNumber"]
        credits          <- map["credits"]
        createTime      <- map["createTime"]
        coins           <- map["coins"]
    }
}
