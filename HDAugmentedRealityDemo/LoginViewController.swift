//
//  LoginViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/18/16.
//

import UIKit
import FacebookLogin
import FacebookCore

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
        if (shouldPerformSegue(withIdentifier: "MoveToMainApp", sender: self)){
            performSegue(withIdentifier: "MoveToMainApp", sender: self)
            NSLog("User is logged in correctly")
        } else {
            NSLog("User needs to login")
        }
        
    }
    
    @IBAction func facebookLoginButton(sender: UIButton) {
        let loginManager = LoginManager()
        var facebookUserID = ""
        
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
                        NSLog("Graph Request Succeeded: \(response)")
                        facebookUserID = (response.dictionaryValue?["id"] as? String)!
                        NSLog("User ID " + facebookUserID)
                    case .failed(let error):
                        NSLog("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
                
                
                
            }
        }
    }
}

