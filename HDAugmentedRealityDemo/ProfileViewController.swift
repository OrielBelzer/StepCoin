//
//  ProfileViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/7/16.
//  Copyright © 2016 Danijel Huis. All rights reserved.
//

import UIKit
import CoreLocation
import Toucan
import Haneke

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
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet weak var numberOfCoins: UILabel!
    @IBOutlet weak var numberOfDollars: UILabel!
    @IBOutlet weak var numberOfStores: UILabel!
    
    let defaults = UserDefaults.standard
    let cache = Shared.dataCache

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var profilePicImage: UIImage
        if ((defaults.object(forKey: "loginMode") as? String) == "facebook") {
            if let url = NSURL(string: (defaults.object(forKey: "facebookProfilePic") as? String)!) {
                if let data = NSData(contentsOf: url as URL) {
                    defaults.set(data, forKey: "userProfilePic")
                    defaults.synchronize()
                }        
            }
        }
        if let profilePicData = defaults.object(forKey: "userProfilePic") as? NSData {
            profilePicImage = UIImage(data: profilePicData as Data)!
        } else {
            profilePicImage = UIImage(named: "UserPicPlaceHolder")!
        }
        
        let resizedImage = Toucan.Resize.resizeImage(profilePicImage, size: CGSize(width: 100, height: 150))
        let resizedAndMaskedImage = Toucan(image: resizedImage).maskWithEllipse(borderWidth: 1, borderColor: UIColor.white).image
        profilePic.image = resizedAndMaskedImage
        
        editProfileButton.layer.cornerRadius = 20
        editProfileButton.layer.borderWidth = 0
        editProfileButton.layer.masksToBounds = true;

        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        collectedCoinsTable.register(nib, forCellReuseIdentifier: "customCell")
        
        self.collectedCoinsTable.backgroundColor = UIColor.clear
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func logout(sender: UIButton) {
        performSegue(withIdentifier: "MoveToLoginScreen", sender: self)
    }
    
    @IBAction func editProfileButton(sender: UIButton) {
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        var numberOfCoins = 0
        cache.fetch(key: "user").onSuccess { data in
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                numberOfCoins = (user.coins?.count)!
            }
        }
        return numberOfCoins
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.collectedCoinsTable.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        let specificCoin = CoinsController().coins[indexPath.row]
        cell.loadItem(worth: specificCoin.worth , address: specificCoin.address, type: specificCoin.type, logoURL: specificCoin.businessLogoLink)

        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        collectedCoinsTable.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}
