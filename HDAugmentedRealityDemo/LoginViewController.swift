//
//  LoginViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/18/16.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        self.defaults.set("YES", forKey: "LoginStatus")
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (self.defaults.bool(forKey: "LoginStatus")) {
            return true
        } else {
            return false
        }
    }
    
    
    @IBAction func loginButton(sender: UIButton) {
        if (shouldPerformSegue(withIdentifier: "MoveToMainApp", sender: self)){
            performSegue(withIdentifier: "MoveToMainApp", sender: self)
            NSLog("User is logged in correctly")
        } else {
            NSLog("User needs to login")
        }
        
    }
    
}

