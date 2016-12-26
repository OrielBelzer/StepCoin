//
//  Store.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/24/16.
//

import ObjectMapper
import CoreLocation
import Haneke

class Store: NSObject, NSCoding, Mappable {
    var id: Int?
    var city: String?
    var name: String?
    var businessUserId: Int?
    var locationId: Int?
    var logoURL: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                      <- map["id"]
        city                    <- map["city"]
        name                    <- map["name"]
        businessUserId          <- map["business_user_id"]
        locationId              <- map["location_id"]
        logoURL                 <- map["logo"]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self.id == (object as? Store)?.id
    }

    static func ==(left: Store, right: Store) -> Bool {
        return left.id == right.id
    }
    
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.city = aDecoder.decodeObject(forKey: "city") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.businessUserId = aDecoder.decodeObject(forKey: "businessUserId") as? Int
        self.locationId = aDecoder.decodeObject(forKey: "locationId") as? Int
        self.logoURL = aDecoder.decodeObject(forKey: "logoURL") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(businessUserId, forKey: "businessUserId")
        aCoder.encode(locationId, forKey: "locationId")
        aCoder.encode(logoURL, forKey: "logoURL")

    }
}


extension Store : DataConvertible, DataRepresentable {
    
    public typealias Result = Store
    
    public class func convertFromData(_ data:Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Store
    }
    
    public func asData() -> Data! {
        return (NSKeyedArchiver.archivedData(withRootObject: self) as NSData!) as Data!
    }
}
