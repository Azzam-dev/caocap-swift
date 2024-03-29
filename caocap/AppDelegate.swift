//
//  AppDelegate.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 15/01/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // IQKeyboardManagerSwift : a great Keyboard Manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40
        
        // this is used to make the keyboard Appearance dark
        UITextField.appearance().keyboardAppearance = .dark
        
        window?.overrideUserInterfaceStyle = .light
        
        // Firebase configuration
        FirebaseApp.configure()
        checkIntroStatus()
        checkMinimumVersionStatus()
        checkRepairStatus()
        
        return true
    }
    
    fileprivate func checkRepairStatus() {
        //this checks if the app is in repair mode and if it is , it will present the repairsVC and if the repair is finished it will dismiss repairsVC
        DataService.instance.REF_REPAIRING.observe(DataEventType.value, with: { snap in
            var repairing = Bool()
            repairing = snap.value! as! Bool
            if repairing {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let repairsVC = storyboard.instantiateViewController(withIdentifier: "repairs")
                repairsVC.modalPresentationStyle = .fullScreen
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController?.present(repairsVC, animated: true, completion: nil)
            }
        })
    }
    
    fileprivate func checkMinimumVersionStatus() {
        //check app version and if it is smaller than the minimum version from Firebase datab base, request the user to update the app by showing the update
        let versionObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = Double(versionObject as! String)!
        // get the minimum version from Firebase
        var minimumVersion = Double()
        DataService.instance.REF_MINIMUM_VERSION.observe(DataEventType.value, with: { snap in
            print(snap.value!)
            minimumVersion = snap.value! as! Double
            // compare the versions
            if minimumVersion > version {
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let updateVC = storyboard.instantiateViewController(withIdentifier: "update")
                updateVC.modalPresentationStyle = .fullScreen
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController?.present(updateVC, animated: true , completion: nil)
            }
        })
    }
    
    fileprivate func checkIntroStatus() {
        
        let status = UserDefaults.standard.didUserCompleteIntro()
        
        if status == false {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let inroVC = storyboard.instantiateViewController(withIdentifier: "IntroVC")
            inroVC.modalPresentationStyle = .fullScreen
            self.window?.makeKeyAndVisible()
            self.window?.rootViewController?.present(inroVC, animated: true, completion: nil)
            
        } else {
            checkCurrentUserStatus()
        }
    }
    
    func checkCurrentUserStatus() {
        //check if the user is logged in or not if not send them to the login/ register VC
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let authVC = storyboard.instantiateViewController(withIdentifier: "auth")
            authVC.modalPresentationStyle = .fullScreen
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(authVC, animated: true , completion: nil)
        }
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "caocap")
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
    }

}

