//
//  Location.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/22/16.
//

import ObjectMapper
import CoreLocation

class Location: Mappable {
    var id: Int?
    var longitude: String?
    var latitude: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        longitude       <- map["x"]
        latitude        <- map["y"]
    }
    
    func getLocationObject() -> CLLocation {
        let latitude: CLLocationDegrees = Double(self.latitude!)!
        let longitude: CLLocationDegrees = Double(self.longitude!)!
        
        return CLLocation(latitude: latitude, longitude: longitude)
        
    }
}
