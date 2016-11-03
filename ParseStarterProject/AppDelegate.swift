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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.customizeApp()
        
//        KingfisherHelper.sharedInstance.clearAllCache()
    
        self.configureParse(application, launchOptions: launchOptions)

//        ParseHelper.logOut()
        
        return true
    }
    
    //--------------------------------------
    // MARK: - App Customization
    //--------------------------------------

    func customizeApp() {

        // Light status bar color
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        self.customizeNavBar()
        self.customizeTabBar()
    }
    
    func customizeNavBar() {
        // Set Navigation bar background color
        UINavigationBar.appearance().barTintColor = Helpers.sharedInstance.getRedColor()
        UINavigationBar.appearance().backgroundColor = Helpers.sharedInstance.getRedColor()
        
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = false
        // Sets background to a blank/empty image
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        
        // Set Navigation bar Title font & color
        UINavigationBar.appearance().titleTextAttributes = ([NSFontAttributeName: Helpers.sharedInstance.getTextFont(20, bold: true) ,NSForegroundColorAttributeName:UIColor.white])
        
        // Set Navigation bar tint color
        UINavigationBar.appearance().tintColor = UIColor.white
        
        // Set bar button items font
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: Helpers.sharedInstance.getTextFont(18)], for: UIControlState())
    }
    
    func customizeTabBar() {
        // Set Tab bar color
        // SPLIT TEST: color - f2e1d2
        UITabBar.appearance().barTintColor = Helpers.sharedInstance.uicolorFromHex(0xf2f0ea)
        
        // Set Tab bar selected item color
        UITabBar.appearance().tintColor = Helpers.sharedInstance.getRedColor()

        // Set tab bar selected/unselected text color and font
        let font = Helpers.sharedInstance.getTextFont(10)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: self.getUnselectedTabBarItemColor(), NSFontAttributeName: font], for:UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: Helpers.sharedInstance.getRedColor(), NSFontAttributeName: font], for:.selected)
        
        // Set tab bar items icons and text
        if let tabBarController = self.window?.rootViewController as? UITabBarController {
            let tabBar = tabBarController.tabBar
            if let tabBarItems = tabBar.items {
                self.setTabBarItemApperance(tabBarItems[0], title: "categories", icon: FontAwesome.thList)
                self.setTabBarItemApperance(tabBarItems[1], title: "Favorites", icon: FontAwesome.heart)
                self.setTabBarItemApperance(tabBarItems[2], title: "Recipes", icon: FontAwesome.cutlery)
                self.setTabBarItemApperance(tabBarItems[3], title: "About", icon: FontAwesome.info, size: CGSize(width: 35, height: 35))
            }
        }
    }
    
    func setTabBarItemApperance(_ tabBarItem: UITabBarItem, title: String, icon: FontAwesome, size: CGSize = CGSize(width: 30, height: 30)) {

        tabBarItem.title = getLocalizedString(title)
        tabBarItem.image = UIImage.fontAwesomeIcon(name: icon, textColor: UIColor.black, size: size)
        
        // Set unselected tab bar image color
        if let image = tabBarItem.image {
            tabBarItem.image = image.imageWithColor(self.getUnselectedTabBarItemColor()).withRenderingMode(.alwaysOriginal)
        }

    }
    
    func getUnselectedTabBarItemColor() -> UIColor {
        return Helpers.sharedInstance.uicolorFromHex(0x42413c)
    }
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    /*
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
    */
 
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

    func configureParse(_ application: UIApplication, launchOptions: [AnyHashable: Any]?) {
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("TfxEtNghomvfES82wGReLepDKSmQcgq5wJwQqxIi",
                               clientKey: "p8ZdtbGbMmlbYAhDEXGQ9iIcJDkfzNroNnMvdW03")
        
        //        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.setPublicReadAccess(true)
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser:true)
        
        /*
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        if application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            
            
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        */
    }
}
