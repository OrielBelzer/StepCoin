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
import SwiftyJSON
import Crashlytics

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet var collectedCoinLogo: UIImageView!
    @IBOutlet var collectedCoinAmount: UILabel!
    @IBOutlet var collectedCoinAddress: UILabel!
    
    func loadItem(worth: String, address: String, type: String, logoURL: String) {
        collectedCoinAmount.text = "$"+worth
        collectedCoinAddress.text = address
        
        if logoURL == "" {
            collectedCoinLogo.image = UIImage(named: "CoinImage")
        } else {
            if let url = NSURL(string: logoURL) {
                collectedCoinLogo.hnk_setImageFromURL(url as URL)
                //loadImageFromURL(urlString: logoURL)
            }
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

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var collectedCoinsTable: UITableView!
    @IBOutlet var editProfileButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet weak var numberOfCoins: UILabel!
    @IBOutlet weak var numberOfDollars: UILabel!
    @IBOutlet weak var numberOfStores: UILabel!
    @IBOutlet weak var addCoinButton: UIButton!
    @IBOutlet weak var editProfilePicButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let defaults = UserDefaults.standard
    let cache = Shared.dataCache

    var imagePicker = UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        profileName.text = ""
        var profilePicImage: UIImage
        let loginMode = (defaults.object(forKey: "loginMode") as? String)
        if (loginMode == "facebook" || loginMode == "twitter") {
            profileName.text = (defaults.object(forKey: "userFullName") as? String)!
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
        
        backgroundImage.frame = self.view.bounds

        
    }

    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        ConnectionController.sharedInstance.getUser(userId: (self.defaults.object(forKey: "userId") as? String)!)  { (responseObject:[AnyObject], error:String) in
            if (error == "") {
                UserController().calcUserQuantities()
                StoreController().getStoresForCoins(coinsToGetStoresFor: ((responseObject[0] as? User)?.coins)!)
                self.collectedCoinsTable.reloadData()

            } else {
                print(error)
            }
            
            if (self.userDefaultsAlreadyExist(key: "userNumberOfCoins")) {
                print((self.defaults.object(forKey: "userNumberOfCoins") as? Int)!)
                self.numberOfCoins.text = String((self.defaults.object(forKey: "userNumberOfCoins") as? Int)!)
            }
            if (self.userDefaultsAlreadyExist(key: "userSumOfCoinsValue")) {
                self.numberOfDollars.text = "$" + String((self.defaults.object(forKey: "userSumOfCoinsValue") as? Double)!)
            }
            if (self.userDefaultsAlreadyExist(key: "userSumOfCoinsStores")) {
                print((self.defaults.object(forKey: "userSumOfCoinsStores") as? Int)!)
                self.numberOfStores.text = String((self.defaults.object(forKey: "userSumOfCoinsStores") as? Int)!)
            }
        }
        
        var profilePicImage: UIImage
        if let profilePicData = defaults.object(forKey: "userProfilePic") as? NSData {
            profilePicImage = UIImage(data: profilePicData as Data)!
        } else {
            profilePicImage = UIImage(named: "UserPicPlaceHolder")!
        }
        let resizedImage = Toucan.Resize.resizeImage(profilePicImage, size: CGSize(width: 100, height: 150))
        let resizedAndMaskedImage = Toucan(image: resizedImage).maskWithEllipse(borderWidth: 1, borderColor: UIColor.white).image
        profilePic.image = resizedAndMaskedImage
    }
    
    @IBAction func editProfilePicButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImagePNGRepresentation(image)
            defaults.set(data, forKey: "userProfilePic")
            defaults.synchronize()
            
            let resizedAndMaskedImage = Toucan(image: image).maskWithEllipse(borderWidth: 5, borderColor: UIColor.white).image
            profilePic.image = resizedAndMaskedImage
        } else{
            NSLog("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func logout(sender: UIButton) {
        defaults.set(false, forKey: "loginStatus")
        defaults.set("", forKey: "userProfilePic")
        defaults.set("", forKey: "facebookProfilePic")
        defaults.set("", forKey: "lastUserLongitude")
        defaults.set("", forKey: "lastUserLatitude")
        defaults.set(0, forKey: "userNumberOfCoins")
        defaults.synchronize()
        
        Shared.dataCache.fetch(key: "stores").onSuccess { data in
            if let stores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Store] {
                print(stores.count)
            }
        }
        
        self.cache.remove(key: "stores")
    }
    
    /* HACK TO ADD A COIN - REMOVE IN GA*/
    
    @IBAction func addCoinButton(sender: UIButton) {
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation
        currentLocation = locManager.location!
        
        let lat = currentLocation.coordinate.latitude // 37.241681
        let lon = currentLocation.coordinate.longitude // -121.884804
        
        ConnectionController.sharedInstance.addCoin(longitude: String(lon), latitude: String(lat))  { (responseObject:SwiftyJSON.JSON, error:String) in
            if (error == "") {
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func editProfileButton(sender: UIButton) {
        
    }
    
    func userDefaultsAlreadyExist(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        var numberOfCoins = 0
        if (userDefaultsAlreadyExist(key: "userNumberOfCoins")) {
            numberOfCoins = (defaults.object(forKey: "userNumberOfCoins") as? Int)!
        }
        
        return numberOfCoins
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomTableViewCell = self.collectedCoinsTable.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        
        Shared.dataCache.fetch(key: "user").onSuccess { data in
            if let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
                if (user.coins?.count != 0) {
                    let userCollectedCoin = user.coins?[indexPath.row]
                    Shared.dataCache.fetch(key: "stores").onSuccess { data in
                        if let stores = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Store] {
                            for store in stores {
                                if store.id == userCollectedCoin?.storeId {
                                    cell.loadItem(worth: (userCollectedCoin?.value)!, address: (userCollectedCoin?.location?.address)!, type: "1", logoURL: store.logoURL!)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        //let specificCoin = CoinsController().coins[indexPath.row]
        //cell.loadItem(worth: specificCoin.worth , address: specificCoin.address, type: specificCoin.type, logoURL: specificCoin.businessLogoLink)
        
        return cell
    }
    
    func buildCell(onCompletion: UITableViewCell) -> Void {
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
