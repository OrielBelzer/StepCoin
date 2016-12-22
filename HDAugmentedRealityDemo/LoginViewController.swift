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
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName: UIColor.white])
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
        ConnectionController.sharedInstance.login(emailAddress: emailTextField.text!, password: passwordTextField.text!) { (responseObject:JSON, error:String) in
            if (error == "") {
                self.performSegue(withIdentifier: "MoveToMainAppFromRegistration", sender:self)
                self.defaults.set(true, forKey: "loginStatus")
                self.defaults.setValue("regular", forKey: "loginMode")
            } else {
                self.showAlert(title: "Error", message: "Please check your credentials and try again")
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
                        ConnectionController.sharedInstance.registerUser(emailAddress: (response.dictionaryValue?["email"] as? String)!, password: (response.dictionaryValue?["id"] as? String)!) { (responseObject:JSON, error:String) in
                            if (error == "") {
                                self.defaults.set(true, forKey: "loginStatus")
                                self.defaults.setValue("facebook", forKey: "loginMode")
                                let userID = (response.dictionaryValue?["id"] as? String)!
                                self.defaults.setValue("http://graph.facebook.com/\(userID)/picture?type=large", forKey: "facebookProfilePic")
                                self.performSegue(withIdentifier: "MoveToMainApp", sender: self)
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
}

