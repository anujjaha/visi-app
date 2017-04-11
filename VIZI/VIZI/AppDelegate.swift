//
//  AppDelegate.swift
//  VIZI
//
//  Created by Bhavik on 13/12/16.
//  Copyright © 2016 GWBB. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var arrLoginData = NSDictionary() //Array of dictionary
    var locationManager:CLLocationManager!
    var userLocation = CLLocation()
    var iNewLocationCategoryID = Int()
    var arrNewLocationPhotos = NSMutableArray()
    var strNewLocationCategoryName = NSString()
    var strDeviceToken = NSString()
    var bUserSelfProfile = Bool()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.determineCurrentLocation()

        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBar"), for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.redColor(),
//            NSFontAttributeName : UIFont(name: "Futura", size: 10)!
//        ]
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        IQKeyboardManager.sharedManager().enable = true
        //IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldHidePreviousNext = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        strDeviceToken = "asdfghjkl"
        
        GMSServices.provideAPIKey("AIzaSyAHzDuGmg_K3kzErQuNRAXfScRFCZM_sN4")
        
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                // Enable or disable features based on authorization.
                if granted == true
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else
                {
                    print("Don't Allow")
                }
            }
        }
        else
        {
            // Fallback on earlier versions
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }


        if (userDefaults.bool(forKey: kkeyisUserLogin))
        {
            let outData = userDefaults.data(forKey: kkeyLoginData)
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!)
            self.arrLoginData = dict as! NSDictionary
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tabbar", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
        }
        else
        {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.isNavigationBarHidden = true
            appdelegate.window!.rootViewController = nav
        }
        return true
    }

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
        UserDefaults.standard.register(defaults: [kkeyisUserLogin : false])
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Push Notification Service
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print(deviceToken)
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        strDeviceToken = deviceTokenString as NSString
    } 

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    {
        print("Push Notification Info:>%@", userInfo)
        var apsInfo: [AnyHashable: Any]? = (userInfo["aps"] as? [AnyHashable: Any])
        let alert: NSDictionary? = (apsInfo?["alert"] as? NSDictionary)
        
        let state:UIApplicationState = application.applicationState
        if (state == UIApplicationState.active) // active --- forground
        {
            if alert != nil
            {
                let strmessage = alert!["body"] as! String
                App_showAlert(withMessage: strmessage, inView: (self.window?.rootViewController)!)
            }
        }
        print("alert:>%@", alert)

    }
    
    //MARK: Location Methods
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.userLocation = locations[0] as CLLocation
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}

