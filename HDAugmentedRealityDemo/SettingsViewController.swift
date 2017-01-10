//
//  SettingsViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 1/7/2017.
//  Copyright © 2016 StepCoin. All rights reserved.
//

import UIKit
import PopupDialog

class SettingsViewController: UIViewController
{
    @IBOutlet weak var debugModeSwitch: UISwitch!
    @IBOutlet weak var backButton: UIButton!
    let debugPasscode = "123456"
    let defaults = UserDefaults.standard


    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (defaults.bool(forKey: "debugMode")) {
            self.debugModeSwitch.setOn(true, animated: true)
        } else {
            self.debugModeSwitch.setOn(false, animated: true)
        }
    }
    
    func switchIsChanged(mySwitch: UISwitch) {
        if mySwitch.isOn {
            print("debug switch is on")
        } else {
            print("debug switch is off")
        }
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.performSegue(withIdentifier: "MoveToProfileFromSettings", sender: self)
    }
    
    @IBAction func debugModeButtonTapped(sender: AnyObject) {
        if debugModeSwitch.isOn {
            print("Debug mode switched to on")
            let DebugModePassCodePopupView = DebugPasscodePopupViewController(nibName: "DebugPasscodePopupViewController", bundle: nil)
            let popup = PopupDialog(viewController: DebugModePassCodePopupView, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
            
            let okButton = DefaultButton(title: "OK") {
                if (DebugModePassCodePopupView.debugPasscodeTextField.text == self.debugPasscode) {
                    //App is in debug mode - BE CARFUL WITH ADDING COINS !!!!!
                    self.defaults.set(true, forKey: "debugMode")
                } else {
                    self.debugModeSwitch.setOn(false, animated: true)
                    let alertController = UIAlertController(title: "Wrong Passcode", message: "Plase try re-enter your debug mode passcode", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.defaults.set(false, forKey: "debugMode")
                }
            }
            popup.addButtons([okButton])
            
            present(popup, animated: true, completion: nil)
        } else {
            print("Debug mode switched to off")
            defaults.set(false, forKey: "debugMode")
        }
    }

}

