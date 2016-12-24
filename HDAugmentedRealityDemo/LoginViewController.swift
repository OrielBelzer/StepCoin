//
//  LoginViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/18/16.
//

import UIKit
import FacebookLogin
import FacebookCore
import SwiftyJSON
import Haneke

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!

    let defaults = UserDefaults.standard

    override func viewDidLoad()
    {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        registerButton.layer.cornerRadius = 10
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
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
    
    @IBAction func registrationButton(sender: UIButton) {
        performSegue(withIdentifier: "MoveToRegistration", sender: self)
    }
    
    @IBAction func loginButton(sender: UIButton) {
        
        /*
         ConnectionController.sharedInstance.getCoins()  { (responseObject:[AnyObject], error:String) in
            if (error == "") {
                let returnedCoins = responseObject as! [Coin2]
                print(returnedCoins[0].value!)
            } else {
                print(error)
            }
        }
        
        Shared.dataCache.fetch(key: "coins").onSuccess { data in
            if let coins = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Coin2] {
                print(coins[0].value!)
            }
        }
        */
        
        performLogin(emailAddress: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func facebookLoginButton(sender: UIButton) {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                let connection = GraphRequestConnection()
                let params = ["fields" : "email, name, gender, picture"]
                connection.add(GraphRequest(graphPath: "/me", parameters: params)) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        ConnectionController.sharedInstance.registerUser(emailAddress: (response.dictionaryValue?["email"] as? String)!, password: (response.dictionaryValue?["id"] as? String)!) { (responseObject:SwiftyJSON.JSON, error:String) in
                            if (error == "") {
                                self.performLogin(emailAddress: (response.dictionaryValue?["email"] as? String)!, password: (response.dictionaryValue?["id"] as? String)!)
                                self.defaults.setValue("facebook", forKey: "loginMode")
                                let userID = (response.dictionaryValue?["id"] as? String)!
                                self.defaults.setValue("http://graph.facebook.com/\(userID)/picture?type=large", forKey: "facebookProfilePic")
                            } else {
                                print("Error logging you in!")
                            }
                        }
                    case .failed(let error):
                        NSLog("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func performLogin(emailAddress: String, password: String){
        ConnectionController.sharedInstance.login(emailAddress: emailAddress, password: password) { (responseObject:SwiftyJSON.JSON, error:String) in
            if (error == "") {
                print(responseObject["id"])
                self.defaults.set(responseObject["id"].string, forKey: "userId")
                
                ConnectionController.sharedInstance.getUser(userId: String(describing: responseObject["id"]))  { (responseObject1:[AnyObject], error:String) in
                    if (error == "") {
                        self.defaults.set(true, forKey: "loginStatus")
                        self.performSegue(withIdentifier: "MoveToMainApp", sender: self)
                    } else {
                        self.defaults.set(false, forKey: "loginStatus")
                        print(error)
                    }
                }
                
            } else {
                self.showAlert(title: "Error", message: "Please check your credentials and try again")
            }
        }
    }
}

