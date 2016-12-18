//
//  CoinsController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/17/16.
//

import CoreLocation


open class CoinsController
{
    open var coins = [Coin]()

    init() {
        self.coins = self.getCoins()
    }
    
    /// PUBLIC FUNCTIONS ///
    
    func getCoins() -> [Coin]{
        
        //Assuming this is the result I got from the server
        //Structure is - lat, long, adress as string (filled in on load), type of coin, name of business (in case type 2), link to URL logo in case type 2, worth
    
        var coinsFromServer: [(String, String, String, String, String, String, String)] = [
            ("37.7767902", "-122.4164055" , "", "2", "Walgreen" , "https://a.yipitcdn.com/yc/logo/walgreens-1403027143.jpg", "$1"),
            ("37.241681", "-121.88480400000003" , "", "1", "" , "", "$0.5"),
            ("37.351507", "-121.981114" , "", "2", "Big Mug Coffee" , "https://qph.ec.quoracdn.net/main-qimg-42a047420a707f34a6c6bf703766e528-c?convert_to_webp=true", "$1"),
            ("37.35190817557375", "-121.9835615158081" , "", "1", "" , "", "$1"),
            ("37.35190817557375", "-121.9835615158081" , "", "1", "" , "", "$2")
            
        ]
        
        var coins = [Coin]()
        for coinFromServer in coinsFromServer {
            var coin = Coin(longitude: coinFromServer.1, latitude: coinFromServer.0, address: coinFromServer.2, type: coinFromServer.3, businessName: coinFromServer.4, businessLogoLink: coinFromServer.5, worth: coinFromServer.6)
            coins.append(coin)
        }
        
        return coins
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

