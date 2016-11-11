//
//  ProfileViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/7/16.
//  Copyright © 2016 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation


class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet var collectedCoinLogo: UIImageView!
    @IBOutlet var collectedCoinAmount: UILabel!
    @IBOutlet var collectedCoinAddress: UILabel!
    
    func loadItem(worth: String, address: String, type: String, logoURL: String) {
        collectedCoinAmount.text = worth
        collectedCoinAddress.text = address
        
        if type == "1" {
            collectedCoinLogo.image = UIImage(named: "CoinImage")
        } else {
            loadImageFromURL(urlString: logoURL)
        }
        
    }
    
    func loadImageFromURL(urlString:String)
    {
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                collectedCoinLogo.image = UIImage(data: data as Data)
            }        
        }
        
    }
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var collectedCoinsTable: UITableView!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var inviteFriendsButton: UIButton!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileName: UILabel!
    
    //Structure is - lat, long, adress as string (filled in on load), type of coin, name of business (in case type 2), link to URL logo in case type 2, worth

    var coins: [(String, String, String, String, String, String, String)] = [
        ("37.241681", "-121.88480400000003" , "", "1", "" , "", "$0.5"),
        ("37.351507", "-121.981114" , "", "2", "Big Mug Coffee" , "https://qph.ec.quoracdn.net/main-qimg-42a047420a707f34a6c6bf703766e528-c?convert_to_webp=true", "$1"),
        ("37.35190817557375", "-121.9835615158081" , "", "1", "" , "", "$1"),
        ("37.35190817557375", "-121.9835615158081" , "", "1", "" , "", "$2")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        
        inviteFriendsButton.layer.cornerRadius = 10
        inviteFriendsButton.layer.borderWidth = 1
        inviteFriendsButton.layer.borderColor = UIColor.black.cgColor
        inviteFriendsButton.layer.backgroundColor = UIColor(colorLiteralRed: 218, green: 165, blue: 32, alpha: 1).cgColor
        
        settingsButton.layer.backgroundColor = UIColor(colorLiteralRed: 218, green: 165, blue: 32, alpha: 1).cgColor
        settingsButton.layer.cornerRadius = 10
        settingsButton.layer.borderWidth = 1
        settingsButton.layer.borderColor = UIColor.black.cgColor
        
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        collectedCoinsTable.register(nib, forCellReuseIdentifier: "customCell")
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        convertCoinsCoordinatesToAddress(shouldReloadTableData: true)
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.collectedCoinsTable.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        var (lat, long, address, type, name, logoURL, worth) = coins[indexPath.row]
        cell.loadItem(worth: worth, address: address, type: type, logoURL: logoURL)

        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collectedCoinsTable.deselectRow(at: indexPath as IndexPath, animated: true)
        //println("You selected cell #\(indexPath.row)!")
    }
    
    func convertCoinsCoordinatesToAddress(shouldReloadTableData: Bool)
    {
        var index = 0
        for coin in coins {
            
            let longitude :CLLocationDegrees = Double(coin.1)!
            let latitude :CLLocationDegrees = Double(coin.0)!
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            reverseGeoLocation(location: location, index: index, shouldReloadTableData: shouldReloadTableData)
            
            index += 1
            
        }

    }
    
    func reverseGeoLocation(location: CLLocation, index: Int, shouldReloadTableData: Bool) {
        let geoCoder = CLGeocoder()

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if (placeMark != nil) {
                let streetAddress = (placeMark.thoroughfare != nil) ? placeMark.thoroughfare : ""
                let city = (placeMark.locality != nil) ? placeMark.locality : ""
                let zip = (placeMark.postalCode != nil) ? placeMark.postalCode : ""
                let country = (placeMark.country != nil) ? placeMark.country : ""
                let streetAddressNumber = (placeMark.subThoroughfare != nil) ? placeMark.subThoroughfare : ""
                
                self.coins[index].2 = streetAddressNumber! + " " + streetAddress! + ", " + city!
                self.coins[index].2 += ", " + zip! + ", " + country!
            }
            
            if (shouldReloadTableData) {
                self.collectedCoinsTable.reloadData()
            }
            
        })
    }
}
