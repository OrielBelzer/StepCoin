//
//  RegistrationLoginView.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/18/16.
//

import UIKit
import Toucan
import Alamofire
import SwiftyJSON

class RegistrationLoginView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var imagePickerButton: UIButton!

    var imagePicker = UIImagePickerController()

    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        self.emailAddressTextField.delegate=self
        self.passwordTextField.delegate=self
        self.reenterPasswordTextField.delegate=self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        var profilePicImage: UIImage
        
        if let profilePicData = defaults.object(forKey: "userProfilePic") as? NSData {
            profilePicImage = UIImage(data: profilePicData as Data)!
        } else {
            profilePicImage = UIImage(named: "UserPicPlaceHolder")!
        }
        
        let resizedImage = Toucan.Resize.resizeImage(profilePicImage, size: CGSize(width: 100, height: 150))
        let resizedAndMaskedImage = Toucan(image: resizedImage).maskWithEllipse(borderWidth: 1, borderColor: UIColor.white).image
        profilePic.image = resizedAndMaskedImage
        
        emailAddressTextField.layer.frame.size.height = 40
        emailAddressTextField.layer.cornerRadius = 10
        emailAddressTextField.layer.borderWidth = 0.5
        emailAddressTextField.layer.borderColor = UIColor.white.cgColor
        emailAddressTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        passwordTextField.layer.frame.size.height = 40
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        reenterPasswordTextField.layer.frame.size.height = 40
        reenterPasswordTextField.layer.cornerRadius = 10
        reenterPasswordTextField.layer.borderWidth = 0.5
        reenterPasswordTextField.layer.borderColor = UIColor.white.cgColor
        reenterPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re Enter Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        registrationButton.layer.cornerRadius = 10
        registrationButton.layer.borderWidth = 0.5
        registrationButton.layer.borderColor = UIColor.white.cgColor

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func registrationButton(sender: UIButton) {
        var isOKToRegister = false
        if (isValidEmail(emailAddress: emailAddressTextField.text!)) {
            if (passwordTextField.text == reenterPasswordTextField.text) {
                isOKToRegister = true
            }
        }
        
        if (isOKToRegister) {
            ConnectionController.sharedInstance.registerUser(emailAddress: emailAddressTextField.text!, password: passwordTextField.text!) { (responseObject:JSON, error:String) in
                if (error == "") {
                    print("user ID that was created is : " + responseObject.rawString()!)
                    self.defaults.set(true, forKey: "loginStatus")
                    self.defaults.setValue("regular", forKey: "loginMode")
                    self.performSegue(withIdentifier: "MoveToMainAppFromRegistration", sender:self)
                } else {
                    print("Error logging you in!")
                }
            }
        }
    }
    
    @IBAction func imagePickerButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
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
    
    private func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
