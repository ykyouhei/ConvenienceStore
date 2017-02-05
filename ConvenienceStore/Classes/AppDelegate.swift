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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerUserNotification(for: application)
        
        setupFirebase()
        
        setupRootViewController()
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        log.info("Disconnected from FCM.")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }

    
    // MARK: Private Method
    
    private func setupFirebase() {
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
    }
    
    private func setupRootViewController() {
        let rootTabBarController = RootTabBarController()
        
        self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController = rootTabBarController
        
    }
    
}


// MARK: - Notification
extension AppDelegate: UNUserNotificationCenterDelegate, FIRMessagingDelegate {
    
    // MARK: Types
    
    enum Topics: String {
        case newItems = "/topics/newItems"
    }
    
    // MARK: ApplicationDelegate
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
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
    
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        log.info(remoteMessage.appData)
    } 
    
    
    // MARK: Private
    
    fileprivate func registerUserNotification(for application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            UNUserNotificationCenter.current().delegate = self
            
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            log.info("InstanceID token: \(refreshedToken)")
        }
        
        
        connectToFcm()
    }
    
    fileprivate func connectToFcm() {
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { error in
            if let error = error {
                log.error("Unable to connect with FCM. \(error)")
            } else {
                log.info("Connected to FCM.")
                FIRMessaging.messaging().subscribe(toTopic: Topics.newItems.rawValue)
            }
        }
    }
}

