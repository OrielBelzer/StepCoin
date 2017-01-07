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
import Crashlytics
import TwitterKit

class LoginViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
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
        emailTextField.delegate = self
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        passwordTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegistrationLoginView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        backgroundImage.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.defaults.value(forKey: "didRegister") != nil) {
            if (self.defaults.value(forKey: "didRegister") as? Bool)! {
                self.showAlert(title: "Success", message: "You registered successfully, please use your credentials to login")
            }
            self.defaults.set(false, forKey: "didRegister")
        }
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
        performLogin(emailAddress: emailTextField.text!, password: passwordTextField.text!)
        self.defaults.setValue("regular", forKey: "loginMode")
    }
    
    @IBAction func twitterLoginButton(sender: UIButton) {
        Twitter.sharedInstance().logIn { (session, error) -> Void in
            if session != nil {
                ConnectionController.sharedInstance.registerUser(emailAddress: (session?.userName)!, password: (session?.userID)!) { (responseObject:SwiftyJSON.JSON, error:String) in
                    if (error == "") {
                            self.performLogin(emailAddress: (session?.userName)!, password: (session?.userID)!)
                            self.defaults.setValue("twitter", forKey: "loginMode")
                            self.defaults.setValue("@"+(session?.userName)!, forKey: "userFullName")
                    } else {
                        print("Error logging you in!")
                    }
                }
            } else {
                print("Error logging in using Twitter - " + error.debugDescription)
            }
        }
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
                                print(response)
                                self.defaults.setValue("facebook", forKey: "loginMode")
                                let userID = (response.dictionaryValue?["id"] as? String)!
                                self.defaults.setValue("https://graph.facebook.com/\(userID)/picture?type=large", forKey: "facebookProfilePic")
                                self.defaults.setValue((response.dictionaryValue?["name"] as? String)!, forKey: "userFullName")
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
    
    func performLogin(emailAddress: String, password: String){
        ConnectionController.sharedInstance.login(emailAddress: emailAddress, password: password) { (responseObject:SwiftyJSON.JSON, error:String) in
            if (error == "") {
                print(responseObject["id"])
                self.defaults.set(String(describing: responseObject["id"]), forKey: "userId")
                
                ConnectionController.sharedInstance.getUser(userId: String(describing: responseObject["id"]))  { (responseObject1:[AnyObject], error:String) in
                    if (error == "") {
                        let user = (responseObject1[0] as? User)
                        StoreController().getStoresForCoins(coinsToGetStoresFor: ((responseObject1[0] as? User)?.coins)!)
                        UserController().calcUserQuantities()
                        self.defaults.set(true, forKey: "loginStatus")
                       // self.defaults.set(responseObject["id"], forKey: "userId")
                        self.performSegue(withIdentifier: "MoveToMainApp", sender: self)
                        
                        self.logUserToFabric(userId: String(describing: user!.id), userEmail: user!.email!)

                    } else {
                        self.defaults.set(false, forKey: "loginStatus")
                        self.showAlert(title: "Error", message: "Please check your credentials and try again")
                        print(error)
                    }
                }
                
            } else {
                self.showAlert(title: "Error", message: "Please check your credentials and try again")
            }
        }
    }
    
    func logUserToFabric(userId: String, userEmail: String) {
        Crashlytics.sharedInstance().setUserEmail(userEmail)
        Crashlytics.sharedInstance().setUserIdentifier(userId)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField === emailTextField) {
            passwordTextField.becomeFirstResponder()
        }
        
        if (textField.returnKeyType==UIReturnKeyType.go) {
            loginButton.sendActions(for: .touchUpInside)
        }

        
        return true
    }
}

