//
//  AppDelegate.swift
//  ConvenienceStore
//
//  Created by kyo__hei on 2017/01/28.
//  Copyright © 2017年 kyo__hei. All rights reserved.
//

import UIKit
import UserNotifications
import Core_iOS

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import SwiftyUserDefaults

import SwiftyBeaver

let log: SwiftyBeaver.Type = {
    let l = SwiftyBeaver.self
    l.addDestination(ConsoleDestination())
    return l
}()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var  window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        log.info(googleService.get(.adUnitIdForBanner)!)
        
        setupFirebase()
        
        registerUserNotification(for: application)
        
        setupRootViewController()
        
        Defaults[.appLaunchCount] += 1
        
        return true
    }

    
    // MARK: Private Method
    
    private func setupFirebase() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
    }
    
    private func setupRootViewController() {
        let rootTabBarController = RootTabBarController()
        
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = rootTabBarController
        
    }
    
}


// MARK: - Notification
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    
    // MARK: Types
    
    enum Topics: String {
        case newItems = "/topics/newItems"
    }
    
    // MARK: ApplicationDelegate
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            log.info("Message ID: \(messageID)")
        }
        
        // Print full message.
        log.debug(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            log.info("Message ID: \(messageID)")
        }
        
        // Print full message.
        log.debug(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // MARK: UNUserNotificationCenterDelegate
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            log.info("Message ID: \(messageID)")
        }
        
        log.debug(userInfo)
        
        completionHandler([])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            log.info("Message ID: \(messageID)")
        }
        
        log.debug(userInfo)
        
        completionHandler()
    }
    
    
    // MARK: FIRMessagingDelegate
    
    func messaging(_ messaging: Messaging,
                   didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func messaging(_ messaging: Messaging,
                   didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    
    
    // MARK: Private
    
    private func registerUserNotification(for application: UIApplication) {
        
         Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: {_, _ in })
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                      categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
}
