//
//  Coin2.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/22/16.
//

import ObjectMapper
import Haneke

class Coin2: NSObject, NSCoding, Mappable {
    var id: Int?
    var value: String?
    var enabled: String?
    var startDate: String?
    var endDate: String?
    var taken: String?
    var takenDate: String?
    var storeId: Int?
    var location: Location?
    var userId: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        value           <- map["value"]
        enabled         <- map["enabled"]
        startDate       <- map["startDate"]
        endDate         <- map["endDate"]
        taken           <- map["taken"]
        takenDate       <- map["takenDate"]
        storeId         <- map["store_id"]
        location        <- map["location_id"]
        userId          <- map["user_id"]
    }
    
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.value = aDecoder.decodeObject(forKey: "value") as? String
        self.enabled = aDecoder.decodeObject(forKey: "enabled") as? String
        self.startDate = aDecoder.decodeObject(forKey: "startDate") as? String
        self.endDate = aDecoder.decodeObject(forKey: "endDate") as? String
        self.taken = aDecoder.decodeObject(forKey: "taken") as? String
        self.takenDate = aDecoder.decodeObject(forKey: "takenDate") as? String
        self.storeId = aDecoder.decodeObject(forKey: "storeId") as? Int
        self.location = aDecoder.decodeObject(forKey: "location") as? Location
        self.userId = aDecoder.decodeObject(forKey: "userId") as? Int
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(enabled, forKey: "enabled")
        aCoder.encode(startDate, forKey: "startDate")
        aCoder.encode(endDate, forKey: "endDate")
        aCoder.encode(taken, forKey: "taken")
        aCoder.encode(takenDate, forKey: "takenDate")
        aCoder.encode(storeId, forKey: "storeId")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(userId, forKey: "userId")
    }
}


extension Coin2 : DataConvertible, DataRepresentable {
    
    public typealias Result = Coin2
    
    public class func convertFromData(_ data:Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Coin2
    }
    
    public func asData() -> Data! {
        return (NSKeyedArchiver.archivedData(withRootObject: self) as NSData!) as Data!
    }
    
}
