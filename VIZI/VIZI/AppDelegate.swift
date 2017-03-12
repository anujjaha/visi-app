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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var arrLoginData = NSDictionary() //Array of dictionary
    var locationManager:CLLocationManager!
    var userLocation = CLLocation()
    var iNewLocationCategoryID = Int()
    var arrNewLocationPhotos = NSMutableArray()
    var strNewLocationCategoryName = NSString()

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
        self.determineCurrentLocation()
        
        GMSServices.provideAPIKey("AIzaSyAHzDuGmg_K3kzErQuNRAXfScRFCZM_sN4")

        
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

