//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import FacebookShare
import TwitterKit

class ShareUsPopupViewController: UIViewController {

    @IBOutlet weak var FacebookShareButton: UIButton!
    @IBOutlet weak var TwitterShareButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebookSharenButton(sender: UIButton) {
        let url = "http://www.stepcoin.co/site"
        var content = LinkShareContent(url: URL(string: url)!)
        content.description = "Check out StepCoin and start collecting coins while walking!"
        content.title = "Check out StepCoin and start collecting coins while walking!"
        do {
            try ShareDialog.show(from: self, content: content)
        } catch {
            print ("error sharing to facebook")
        }
    }
    
    @IBAction func twitterShareButton(sender: UIButton) {
        let composer = TWTRComposer()
        
        composer.setText("Check out StepCoin and start collecting coins while walking! stepcoin.co/site")
        composer.setImage(UIImage(named: "CollecCoinImage"))
        
        // Called from a UIViewController
        composer.show(from: self) { result in
            if (result == TWTRComposerResult.cancelled) {
                print("Tweet composition cancelled")
            }
            else {
                print("Sending tweet!")
            }
        }
    }
}
