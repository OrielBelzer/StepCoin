//
//  Location.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/22/16.
//

import ObjectMapper
import CoreLocation
import Haneke

class Location: NSObject, NSCoding, Mappable {
    var id: Int?
    var longitude: String?
    var latitude: String?
    var address: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        longitude       <- map["longitude"]
        latitude        <- map["latitude"]
        address         <- map["address"]
    }
    
    func getLocationObject() -> CLLocation {
        let latitude: CLLocationDegrees = Double(self.latitude!)!
        let longitude: CLLocationDegrees = Double(self.longitude!)!
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        self.address = aDecoder.decodeObject(forKey: "address") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(address, forKey: "address")
    }
}


extension Location : DataConvertible, DataRepresentable {
    
    public typealias Result = Location
    
    public class func convertFromData(_ data:Data) -> Result? {
        return NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? Location
    }
    
    public func asData() -> Data! {
        return (NSKeyedArchiver.archivedData(withRootObject: self) as NSData!) as Data!
    }
}
