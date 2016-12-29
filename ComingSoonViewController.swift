//
//  PayViewController.swift
//  StepCoin
//
//  Created by Oriel Belzer on 11/19/16.
//  Copyright © 2016 StepCoin. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI

class ComingSoonViewController: UIViewController, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tellUsButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tellUsButton.layer.cornerRadius = 10
        tellUsButton.layer.borderWidth = 1
        tellUsButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func tellUsButton(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["info@stepcoin.co"])
        mailComposerVC.setSubject("Stores I'd love to see")
        //mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}

