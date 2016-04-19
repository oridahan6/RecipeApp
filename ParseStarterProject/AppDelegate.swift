//
//  AppDelegate.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit

import Bolts
import Parse

// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.customizeApp()
        
//        KingfisherHelper.sharedInstance.clearAllCache()
    
        self.configureParse(application, launchOptions: launchOptions)
        
        return true
    }
    
    //--------------------------------------
    // MARK: - App Customization
    //--------------------------------------

    func customizeApp() {

        // Light status bar color
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        self.customizeNavBar()
        self.customizeTabBar()
    }
    
    func customizeNavBar() {
        // Set Navigation bar background image
        let navBgImage:UIImage = UIImage(named: "navbar.png")!
        UINavigationBar.appearance().setBackgroundImage(navBgImage, forBarMetrics: .Default)
        
        // Set Navigation bar Title font & color
        UINavigationBar.appearance().titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Alef-Bold", size: 20)! ,NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        // Set Navigation bar tint color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Set bar button items font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Alef-Regular", size: 18)!], forState: UIControlState.Normal)
    }
    
    func customizeTabBar() {
        // Set Tab bar tint color
        UITabBar.appearance().tintColor = UIColor(red:0.682, green:0.29, blue:0.302, alpha:1)
        
        // Set tab bar items font
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Alef-Regular", size: 10)!], forState: UIControlState.Normal)
        
        // Set tab bar items icons and text
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            let tabBar = tabBarController.tabBar
            if let tabBarItems = tabBar.items {
                let tabBarItem1 = tabBarItems[0]
                tabBarItem1.title = getLocalizedString("categories")
                tabBarItem1.image = UIImage.fontAwesomeIconWithName(FontAwesome.ThList, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30))
                
                let tabBarItem2 = tabBarItems[1]
                tabBarItem2.title = getLocalizedString("Favorites")
                tabBarItem2.image = UIImage.fontAwesomeIconWithName(FontAwesome.Heart, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30))
                
                let tabBarItem3 = tabBarItems[2]
                tabBarItem3.title = getLocalizedString("Recipes")
                tabBarItem3.image = UIImage.fontAwesomeIconWithName(FontAwesome.Cutlery, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30))
                
                let tabBarItem4 = tabBarItems[3]
                tabBarItem4.title = getLocalizedString("About")
                tabBarItem4.image = UIImage.fontAwesomeIconWithName(FontAwesome.Info, textColor: UIColor.grayColor(), size: CGSizeMake(35, 35))
            }
        }
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded, error) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.", error)
            }
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
//            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
    
    // MARK:- customization

    func configureParse(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("TfxEtNghomvfES82wGReLepDKSmQcgq5wJwQqxIi",
                               clientKey: "p8ZdtbGbMmlbYAhDEXGQ9iIcJDkfzNroNnMvdW03")
        
        //        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
            
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }

    }
}
