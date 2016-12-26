//
//  CoinsController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/17/16.
//

import CoreLocation

open class CoinsController
{
    let defaults = UserDefaults.standard

    /* Used to get coins within certain distance from the current user location */
    func reloadCoinsFromServerWithinCoordinatesRange(longitude: String, latitude: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        if (shouldReloadCoinsFromServerWithinCoordinatesRange(longitude: longitude, latitdue: latitude)) {
            ConnectionController.sharedInstance.getCoins(longitude: longitude, latitude: latitude)  { (responseObject:[AnyObject], error:String) in
                if (error == "") {
                    let returnedCoins = responseObject as! [Coin2]
                    print(returnedCoins[0].value!)
                    onCompletion(responseObject, "")
                } else {
                    print(error)
                    onCompletion([], error)
                }
            }
        }
    }
    
    func reloadCoinsFromServerBasedOnZoom(swLongitude: String, swLatitude: String,neLongitude: String, neLatitude: String, onCompletion: @escaping ServiceResponseAnyObjectArray) -> Void {
        ConnectionController.sharedInstance.getCoinsBasedOnZoom(swLongitude: swLongitude, swLatitude: swLatitude, neLongitude: neLongitude, neLatitude: neLatitude)  { (responseObject:[AnyObject], error:String) in
            if (error == "") {
                let returnedCoins = responseObject as! [Coin2]
                print(returnedCoins[0].value!)
                onCompletion(responseObject, "")
            } else {
                print(error)
                onCompletion([], error)
            }
        }
    }

    
    private func shouldReloadCoinsFromServerWithinCoordinatesRange(longitude: String, latitdue:String) -> Bool {
        if ((defaults.value(forKey: "lastUserLatitude") as? Double) == nil) { //If it is the first attempt to get coins
            defaults.set(Double(longitude), forKey: "lastUserLongitude")
            defaults.set(Double(latitdue), forKey: "lastUserLatitude")
            defaults.synchronize()
            return true
        }
        
        let lastUserCoordinates = CLLocation(latitude: (defaults.value(forKey: "lastUserLatitude") as? Double)!, longitude: (defaults.value(forKey: "lastUserLongitude") as? Double)!)
        let currentUserCoordinates = CLLocation(latitude: Double(latitdue)!, longitude: Double(longitude)!)
        
        let distanceInMeters = lastUserCoordinates.distance(from: currentUserCoordinates)
        
        if (distanceInMeters > 500) {
            defaults.set(Double(longitude), forKey: "lastUserLongitude")
            defaults.set(Double(latitdue), forKey: "lastUserLatitude")
            defaults.synchronize()
            return true
        }
        
        return false
    }
    
    //TODO - The address of the coins should come back from the server and not calculated on the user side to save me the trouble below
    
    
    

//    /// PRIVATE FUNCTIONS ////
//    
//    private func convertCoinsCoordinatesToAddress(coin: Coin) -> String
//    {
//        var index = 0
//        //for coin in self.coins {
//            
//            let longitude :CLLocationDegrees = Double(coin.longitude)!
//            let latitude :CLLocationDegrees = Double(coin.latitude)!
//            let location = CLLocation(latitude: latitude, longitude: longitude)
//            
//            return (reverseGeoLocation(location: location))
//            
//         //   index += 1
//            
//       // }
//        
//    }
//    
//    private func reverseGeoLocation(location: CLLocation) -> String{
//        let geoCoder = CLGeocoder()
//        
//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
//            var placeMark: CLPlacemark!
//            placeMark = placemarks?[0]
//            
//            if (placeMark != nil) {
//                let streetAddress = (placeMark.thoroughfare != nil) ? placeMark.thoroughfare : ""
//                let city = (placeMark.locality != nil) ? placeMark.locality : ""
//                let zip = (placeMark.postalCode != nil) ? placeMark.postalCode : ""
//                let country = (placeMark.country != nil) ? placeMark.country : ""
//                let streetAddressNumber = (placeMark.subThoroughfare != nil) ? placeMark.subThoroughfare : ""
//                
//                //self.coins[index].2 = streetAddressNumber! + " " + streetAddress! + ", " + city!
//                //self.coins[index].2 += ", " + zip! + ", " + country!
//                
//                var coinAddressString = streetAddressNumber! + " " + streetAddress! + ", " + city!
//                coinAddressString += ", " + zip! + ", " + country!
//                
//                return coinAddressString
//            }
//        })
//    }
}

