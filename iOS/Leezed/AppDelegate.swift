//
//  AppDelegate.swift
//  Leezed
//
//  Created by Neha Gupta on 31/08/19.
//  Copyright © 2019 Shertech. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import DropDown
import FBSDKCoreKit
import CoreLocation
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
            
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        GIDSignIn.sharedInstance().clientID = "888196419121-a55rq68mm8bei84p6uf64ik9pb000vkm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        let authToken = Defaults.retrieveDefaults.getAuthToken()
               if String.isEmpty(str: authToken) {
//                let mainViewController = LoginViewController()
//                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
//                window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.rootViewController = nvc
//                self.window?.makeKeyAndVisible()
                self.LoadMenuWithoutLogin()
               }else{
                self.LoadSliderView()
        }
        self.window?.layer.cornerRadius = 5.0
        self.window?.layer.borderWidth = 3.0
        self.window?.layer.borderColor = UIColor.systemOrange.cgColor
        self.window?.clipsToBounds = true
        self.window?.backgroundColor = UIColor.black
        return true
    }
    
    func LoadSliderView() {
        let mainViewController = HomeViewController()
        let leftViewController = MenuViewController()
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        leftViewController.homeViewController = nvc
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        let navMain = UINavigationController(rootViewController: slideMenuController)
        navMain.isNavigationBarHidden = true
        self.window?.rootViewController = navMain
        self.window?.layer.cornerRadius = 5.0
        self.window?.layer.borderWidth = 1.0
        self.window?.layer.borderColor = UIColor.systemOrange.cgColor
        self.window?.clipsToBounds = true
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        
    }
    
    func LoadMenuWithoutLogin() {
        let mainViewController = HomeViewController()
        let leftViewController = MenuWithoutLoginVC()
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        window = UIWindow(frame: UIScreen.main.bounds)
         let navMain = UINavigationController(rootViewController: slideMenuController)
        navMain.isNavigationBarHidden = true
               self.window?.rootViewController = navMain
        self.window?.layer.cornerRadius = 5.0
        self.window?.layer.borderWidth = 1.0
        self.window?.layer.borderColor = UIColor.systemOrange.cgColor
        self.window?.clipsToBounds = true
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
    }
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            
            return ApplicationDelegate.shared.application(application, open: url, options: options)
            
//            return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("\(credential.description)")
        
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let currentLocation = locations[0]
//        locationManager.stopUpdatingLocation()
//        
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(currentLocation, completionHandler: { placemarks, error in
//            if (error) == nil {
//                let placemark = placemarks?[0]
//                print("\nCurrent Location Detected\n")
//                if let placemark = placemark {
//                    print("placemark \(placemark)")
//                }
//                let locationName = (placemark?.addressDictionary?["FormattedAddressLines"] as! NSMutableArray).componentsJoined(by: ", ")
//                let zipCode = placemark?.postalCode ?? ""
//                
//                Defaults.retrieveDefaults.setPostalCode(code: zipCode)
//                Defaults.retrieveDefaults.setLocationName(locationName: locationName)
//            } else {
//                if let error = error {
//                    print("Geocode failed with error \(error)")
//                } // Error handling must required
//            }
//        })
//    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
