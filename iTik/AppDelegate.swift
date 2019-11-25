//
//  AppDelegate.swift
//  iTik
//
//  Created by MILAD on 11/28/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import NotificationCenter
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    let locationManager = CLLocationManager()
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManager.delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound , .badge]) { (granted, error) in
                // Enable or disable features based on authorization.
                self.locationManager.requestAlwaysAuthorization()
            }
        } else {
            // Fallback on earlier versions
            //            locationManager.requestAlwaysAuthorization()
        }
        
        registerBackgroundTask()
        
        locationManager.startMonitoringSignificantLocationChanges()
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        return true
    }
    
    
    ///////////////////////////////////////
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            
            self?.reinstateBackgroundTask()
            
        }
        
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
        
    }
    
    func reinstateBackgroundTask() {
        if (backgroundTask == UIBackgroundTaskIdentifier.invalid) {
            // register background task
            registerBackgroundTask()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var lat: String
        
        var long: String
        
        let locManager = CLLocationManager()
        
        locManager.requestAlwaysAuthorization()
        
        var currentLocation = CLLocation()
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location!
            
        }
        
        long = String(currentLocation.coordinate.longitude)
        
        lat = String(currentLocation.coordinate.latitude)
        
        print("lat and long" , lat , long)
        
        
    }
    
    
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge])
    }
    
    ///////////////////////////////////////
    
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BDingSDK")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        } else {
            // Fallback on earlier versions
        }
    }
    
}

