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
        //convertCoinsCoordinatesToAddress(shouldReloadTableData: true)
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return CoinsController().coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.collectedCoinsTable.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        //var (lat, long, address, type, name, logoURL, worth) = coins[indexPath.row]
        var specificCoin = CoinsController().coins[indexPath.row]
        cell.loadItem(worth: specificCoin.worth , address: specificCoin.address, type: specificCoin.type, logoURL: specificCoin.businessLogoLink)

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
}
