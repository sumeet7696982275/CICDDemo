//
//  AppDelegate.swift
//  DriverDeliveryApp
//
//  Created by Navaldeep Kaur on 30/04/20.
//  Copyright © 2020 Navaldeep Kaur. All rights reserved.
////
//import UIKit
//import CoreData
//import Firebase
//import FirebaseAuth
//import GoogleMaps
//import Alamofire
//import GooglePlaces
//import UserNotifications
//import Network


import UIKit
import CoreData
import Firebase
import FirebaseAuth
import GoogleMaps
import Alamofire
import GooglePlaces
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey(GoogleAPIKey)//("AIzaSyACMesN5EY84ijTPk9OeNZCiv4WBYjzwC0")
        GoogleApi.shared.initialiseWithKey(GoogleAPIKey)
        GMSPlacesClient.provideAPIKey(GoogleAPIKey)
        FirebaseApp.configure()
        registerForPushNotifications()
        AllUtilies.CameraGallaryPrmission()
        set_nav_bar_color()
        setRootViewController()
        //  notificationsHandling()
        
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            //   UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        //  Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
//        Messaging.messaging().token { result, error in
//           // Check for error. Otherwise do what you will with token here
//
//
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
//            }
//
//        }
        
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        
    
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                // self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
//            }
//        }
        
        //Nav bar title Bold
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: Appcolor.kThemeColor, NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 18)]
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Messaging.messaging().apnsToken = deviceToken
    }
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        if #available(iOS 13.0, *) {
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        } else {
            // Fallback on earlier versions
        }
        return UISceneConfiguration()
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //MARK:- Other functions
    func set_nav_bar_color()
    {
        //UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIColor.lightGray.as1ptImage()//UIImage()
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = Appcolor.kThemeColor//UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = Appcolor.kThemeColor//UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font : (UIFont(name: "Helvetica Neue", size: 18))!, NSAttributedString.Key.foregroundColor: Appcolor.kThemeColor]
        
    }
    
    
    func showPermissionAlert()
    {
        let alert = UIAlertController(title: "Alert", message: "Please enable access to Notifications in the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {[weak self] (alertAction) in
            self?.gotoAppSettings()
        }
        
        let cancelAction = UIAlertAction(title: KCancel, style: .default, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    private func gotoAppSettings()
    {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else
        {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl)
        {
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(settingsUrl, options: [:]) { (success) in
                    print(success)
                }
            }
            else
            {
                
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    
    //MARK:- Push Configuration
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register: \(error)")
        AppDefaults.shared.userDeviceToken = "11111111111"
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print("Successfully registered for notifications!")
        let deviceTokenString = deviceToken.hexString
        print(deviceTokenString)
        AppDefaults.shared.userDeviceToken = deviceTokenString
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
        
        
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
              AppDefaults.shared.firebaseToken = "123"
          } else if let token = token {
            print("FCM registration token: \(token)")
              AppDefaults.shared.firebaseToken = token
          }
        }
        
        
//        InstanceID.instanceID().instanceID(handler: { (result, error) in
//            if let error = error
//            {
//                print("Error fetching remote instange ID: \(error)")
//                AppDefaults.shared.firebaseToken = "123"
//            }
//            else if let result = result
//            {
//                print("Remote instance ID token: \(result.token)")
//                AppDefaults.shared.firebaseToken = result.token
//            }
//        })
    }
    
    
    func registerForPushNotifications()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings()
    {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    
    // This function will be called when the app receive notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // show the notification alert (banner), and with sound
        // completionHandler([.alert, .sound])
        // self.playSound()
        completionHandler([.alert, .badge, .sound])
        print(notification.request.content.userInfo as Any)
        //   self.give_me_notification_info(info: notification.request.content.userInfo)
        
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // tell the app that we have finished processing the user’s action / response
        // completionHandler()
        print(response.notification.request.content.userInfo as Any)
        //        let pushContent = response.notification.request.content
        let content = response.notification.request.content
        let badgeCount = content.badge as? Int
        UIApplication.shared.applicationIconBadgeNumber = badgeCount ?? 0
        
        
        
        self.give_me_notification_info(info: response.notification.request.content.userInfo)
        
        //  self.playSound()
    }
    
    
    func give_me_notification_info(info:[AnyHashable : Any])
    {
        if let notif_title = info["title"] as? String
        {
            //print("push user info : \(userInfo)")
            //                   let tmp : AnyObject = userInfo["aps"]! as AnyObject
            //                   //print("the user tmp : \(tmp)")
            //                   let tmp1 : NSString = tmp.object(forKey: "alert") as! NSString
            //                   //print("push user tmp : \(tmp1)")
            //                   pushflag="\(tmp1)" as NSString
            // NotificationCenter.default.post(name: Notification.Name(rawValue: "response:"), object: notif_title)
            //  self.setRootView("LoginWithPhoneVC", storyBoard: "Main")
            
            //  self.setRootView("SWRevealViewController", storyBoard: "Home")
           }
        self.setRootView("SWRevealViewController", storyBoard: "Home")
    }
    
}

extension Data
{
    var hexString: String
    {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

extension AppDelegate
{
    
    func setRootViewController()
    {
        if AppDefaults.shared.userID == "0"
        {
            self.setRootView("LoginWithPhoneVC", storyBoard: "Main")
        }
        else
        {
            self.setRootView("SWRevealViewController", storyBoard: "Home")
        }
    }
    
}
