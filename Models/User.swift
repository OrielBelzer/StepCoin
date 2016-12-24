//
//  User.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/22/16.
//

import ObjectMapper
import Haneke

class User: NSObject, NSCoding, Mappable {
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
        credits         <- map["credits"]
        createTime      <- map["createTime"]
        coins           <- map["coins"]
    }
    
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String
        self.credits = aDecoder.decodeObject(forKey: "credits") as? String
        self.createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        self.coins = aDecoder.decodeObject(forKey: "coins") as? [Coin2]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(credits, forKey: "credits")
        aCoder.encode(createTime, forKey: "createTime")
        aCoder.encode(coins, forKey: "coins")
    }
}


extension User : DataConvertible, DataRepresentable {
    
    public typealias Result = User
    
    public class func convertFromData(_ data:Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? User
    }
    
    public func asData() -> Data! {
        return (NSKeyedArchiver.archivedData(withRootObject: self) as NSData!) as Data!
    }
}
