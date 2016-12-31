//
//  AppDelegate.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 21/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Fabric
import TwitterKit
import Onboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        if ((defaults.value(forKey: "firstTimeUser")) == nil) {
            let firstPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "FirstScreen"), buttonText: "") { () -> Void in }
            let secondPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "SecondScreen"), buttonText: "") { () -> Void in }
            let thirdPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "ThirdScreen"), buttonText: "") { () -> Void in}
            let fourthPage = OnboardingContentViewController(title: "", body: "", image: UIImage(named: "FourthScreen"), buttonText: "Start") { () -> Void in
                self.handleLoginScreens()
            }
        
            let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "OnBoardingBackground"), contents: [firstPage, secondPage, thirdPage, fourthPage])
            onboardingVC?.shouldMaskBackground = false
            
            firstPage.topPadding = 0
            secondPage.topPadding = 0
            thirdPage.topPadding = 0
            fourthPage.topPadding = 0
            
            self.window?.rootViewController = onboardingVC
            
        } else {
            handleLoginScreens()
        }

        Fabric.with([Twitter.self])
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    private func handleLoginScreens() {
        let defaults = UserDefaults.standard

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        //let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! UIViewController
        
        NSLog("Login status when app opened " + defaults.bool(forKey: "loginStatus").description)
        if !(defaults.bool(forKey: "loginStatus"))
        {
            self.window?.rootViewController = loginViewController
            //self.window?.rootViewController = mapViewController
        }
        
        defaults.set(false, forKey: "firstTimeUser")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
}

