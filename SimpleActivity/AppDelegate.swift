//
//  AppDelegate.swift
//  SimpleActivity
//
//  Created by MobileR&D-Sothea007 on 2/4/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // If the app is in the background, and "content-available" == true
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // update activity when the app is in the background
        self.activityAction(userInfo: userInfo)
    }
    
    // If the app is in the foreground, the app will call this
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // create activity when the app is in the foreground or update activity when the app is in the foreground
        self.activityAction(userInfo: notification.request.content.userInfo)
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Get this value for Push notification
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        print("deviceToken : \(deviceTokenString)")
        
    }
    
    public func registerForRemoteNotifications() {
        
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
            
            switch error {
            case .none:
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            case .some(let error):
                
                self.registerForRemoteNotifications()
                
                
                print(error)
                
            }
        }
    }
    
    private func activityAction(userInfo : [AnyHashable:Any] ) {
        
        DispatchQueue.global().async {
            if let userInfo = userInfo["aps"] as? [String:Any] {
                if let status = userInfo["status"] as? String {
                    switch status {
                    case "request" :
                        DispatchQueue.main.async {
                            LiveActivityHelper.shared.startLiveActivity(userInfo: userInfo)
                            
                        }
                    case "process","completed","rejected" :
                        DispatchQueue.main.async {
                            Task {
                                await LiveActivityHelper.shared.updateLiveActivity(status: Status(rawValue: status) ?? .rejected, userInfo: userInfo)
                            }
                        }
                    default :
                        break
                    }
                }
            }
            
        }
    }
}

