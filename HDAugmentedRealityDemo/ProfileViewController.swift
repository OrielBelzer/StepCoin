//
//  ProfileViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/7/16.
//  Copyright © 2016 Danijel Huis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController
{
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
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
