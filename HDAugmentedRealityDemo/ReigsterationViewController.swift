//
//  RegistrationLoginView.swift
//  StepCoin
//
//  Created by Oriel Belzer on 12/18/16.
//

import UIKit
import Toucan

class RegistrationLoginView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var imagePickerButton: UIButton!

    var imagePicker = UIImagePickerController()

    
    
    override func viewDidLoad()
    {
        let profilePicImage = profilePic.image
        let resizedImage = Toucan.Resize.resizeImage(profilePicImage!, size: CGSize(width: 100, height: 150))
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
    
    @IBAction func imagePickerButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //let resizedImage = Toucan.Resize.resizeImage(profilePicImage!, size: CGSize(width: 100, height: 150))
            let resizedAndMaskedImage = Toucan(image: image).maskWithEllipse(borderWidth: 5, borderColor: UIColor.white).image
            profilePic.image = resizedAndMaskedImage
            //profilePic.image = resizedAndMaskedImage
        } else{
            NSLog("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

