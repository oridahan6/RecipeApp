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
        // Set Navigation bar background color
        UINavigationBar.appearance().barTintColor = Helpers.getRedColor()
        UINavigationBar.appearance().backgroundColor = Helpers.getRedColor()
        
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().translucent = false
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // Set Navigation bar Title font & color
        UINavigationBar.appearance().titleTextAttributes = ([NSFontAttributeName: UIFont(name: "Alef-Bold", size: 20)! ,NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        // Set Navigation bar tint color
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // Set bar button items font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Alef-Regular", size: 18)!], forState: UIControlState.Normal)
    }
    
    func customizeTabBar() {
        // Set Tab bar color
        // SPLIT TEST: color - f2e1d2
        UITabBar.appearance().barTintColor = Helpers.uicolorFromHex(0xf2f0ea)
        
        // Set Tab bar selected item color
        UITabBar.appearance().tintColor = Helpers.getRedColor()

        // Set tab bar selected/unselected text color and font
        let font = UIFont(name: "Alef-Regular", size: 10)!
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: self.getUnselectedTabBarItemColor(), NSFontAttributeName: font], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Helpers.getRedColor(), NSFontAttributeName: font], forState:.Selected)
        
        // Set tab bar items icons and text
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            let tabBar = tabBarController.tabBar
            if let tabBarItems = tabBar.items {
                self.setTabBarItemApperance(tabBarItems[0], title: "categories", icon: FontAwesome.ThList)
                self.setTabBarItemApperance(tabBarItems[1], title: "Favorites", icon: FontAwesome.Heart)
                self.setTabBarItemApperance(tabBarItems[2], title: "Recipes", icon: FontAwesome.Cutlery)
                self.setTabBarItemApperance(tabBarItems[3], title: "About", icon: FontAwesome.Info, size: CGSizeMake(35, 35))
            }
        }
    }
    
    func setTabBarItemApperance(tabBarItem: UITabBarItem, title: String, icon: FontAwesome, size: CGSize = CGSizeMake(30, 30)) {

        tabBarItem.title = getLocalizedString(title)
        tabBarItem.image = UIImage.fontAwesomeIconWithName(icon, textColor: UIColor.blackColor(), size: size)
        
        // Set unselected tab bar image color
        if let image = tabBarItem.image {
            tabBarItem.image = image.imageWithColor(self.getUnselectedTabBarItemColor()).imageWithRenderingMode(.AlwaysOriginal)
        }

    }
    
    func getUnselectedTabBarItemColor() -> UIColor {
        return Helpers.uicolorFromHex(0x42413c)
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
