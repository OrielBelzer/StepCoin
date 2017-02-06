//
//  ForgotPasswordViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 2/5/17.
//  Copyright © 2017 Danijel Huis. All rights reserved.
//

import UIKit
import Toucan
import Alamofire
import SwiftyJSON

class ForgotPasswordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        self.emailAddressTextField.delegate=self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ForgotPasswordViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailAddressTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func forgotPasswordButton(sender: UIButton) {
        if (emailAddressTextField.text != "" && !isValidEmail(emailAddress: emailAddressTextField.text!)) {
            ConnectionController.sharedInstance.forgotPassword(userEmail: emailAddressTextField.text!) { (responseObject:SwiftyJSON.JSON, error:String) in
                if (error == "") {
                  print("Succesfully reset password Email was sent to the user")
                  self.showAlert(title: "Success", message: "Check your Email for reset password instruction")
                } else {
                    print("Error reseting password")
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go) {
            forgotPasswordButton.sendActions(for: .touchUpInside)
        }
        
        
        return true
    }
}

