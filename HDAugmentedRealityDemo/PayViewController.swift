//
//  PayViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/19/16.
//  Copyright © 2016 StepCoin. All rights reserved.
//

import UIKit
import CoreLocation


class PayCustomTableViewCell : UITableViewCell {
    
    @IBOutlet var PaymentBarcode: UIImageView!
    @IBOutlet var ExpirationDateAndTime: UILabel!
    @IBOutlet var CoinCode: UILabel!
    @IBOutlet var CollectedCoinLogo: UIImageView!
    @IBOutlet var Worth: UILabel!
    
    
    func loadItem(ExpirationDateAndTime: String, CoinCode: String, type: String, logoURL: String, worth: String) {
       
        //Funciton to be used in order to load the data into each cell
        
        self.ExpirationDateAndTime.text = ExpirationDateAndTime
        self.CoinCode.text = CoinCode
        self.Worth.text = worth
        
        if type == "1" {
            CollectedCoinLogo.image = UIImage(named: "CoinImage")
        } else {
            loadImageFromURL(urlString: logoURL)
        }
        
        
    }
    
    func loadImageFromURL(urlString:String)
    {
        
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOf: url as URL) {
                CollectedCoinLogo.image = UIImage(data: data as Data)
            }
        }
        
    }
    
}

class PayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var PaymentsTable: UITableView!

    //Structure is -  Coin Code, Expiration Date and timem, type of coin, type (1 is generic one), link to URL logo in case type 2, worth
    
    var paymentOptions: [(String, String, String, String, String)] = [
        ("OB-VX67-8PQ3-W72Y-YVLM", "3/15/2017, 11:59PM" , "1", "", "$25.3"),
        ("OB-CC53-PK91-E57U-GQAT", "2/11/2017, 11:59PM" , "2", "https://qph.ec.quoracdn.net/main-qimg-42a047420a707f34a6c6bf703766e528-c?convert_to_webp=true", "$13.4")
    ]

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PayCustomTableViewCell", bundle: nil)
        PaymentsTable.register(nib, forCellReuseIdentifier: "customCell")
        
         
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return paymentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PayCustomTableViewCell = self.PaymentsTable.dequeueReusableCell(withIdentifier: "customCell") as! PayCustomTableViewCell
        
        let (coinCode, expirationDate, type, logoURL, worth) = paymentOptions[indexPath.row]
        cell.loadItem(ExpirationDateAndTime: expirationDate, CoinCode: coinCode, type: type, logoURL: logoURL, worth: worth)
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PaymentsTable.deselectRow(at: indexPath as IndexPath, animated: true)
    }
}
