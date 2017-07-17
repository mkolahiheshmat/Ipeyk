//
//  AppDelegate.swift
//  PeikYab
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import UserNotifications
import UserNotificationsUI
import Google
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate{
    
    var window: UIWindow?
    let API_KEY = "AIzaSyBM5mp-SDZ9kKw7yhhsmetYBuiSG1iEi8g"
    let uuid = NSUUID().uuidString
    //GIDSignIn.sharedInstance().clientID = kClientID
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(API_KEY)
        GMSPlacesClient.provideAPIKey(API_KEY)
        
        registerNotification()
        
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)

        
        //[[NSUserDefaults standardUserDefaults] setObject:@[@"en"] forKey:@"AppleLanguages"];
        UserDefaults.standard.set(["fa"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        //Push Arash
        if #available(iOS 10.0, *) {
            let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert], completionHandler: { (comeOn:Bool, error:Error?) in
                print(comeOn, error as Any)
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            // Fallback on earlier versions
            let notificationTypes: UIUserNotificationType = [/*UIUserNotificationType.alert,*/ UIUserNotificationType.badge/*, UIUserNotificationType.sound*/]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            //application.registerUserNotificationSettings(pushNotificationSettings)
            //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
            UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
        }
        
        return true
    }
    //MARK: - Google Login
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    // [END openurl]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            print("userID = \(userId!)")
            
            let idToken = user.authentication.idToken // Safe to send to the server
            print("idToken = \(idToken!)")
            
            //let fullName = user.profile.name
            //print("fullName = \(fullName!)")
            //let givenName = user.profile.givenName
            //print("givenName = \(givenName!)")
            //let familyName = user.profile.familyName
            //print("familyName = \(familyName!)")
            //let email = user.profile.email
            //print("email = \(email!)")
            
            let googleInfo = ["idToken": idToken!, "uid": userId!]
            let notificationName = Notification.Name("googleLogin")
            NotificationCenter.default.post(name: notificationName, object: googleInfo)
            
            // [START_EXCLUDE]
            //            NotificationCenter.default.post(
            //                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            //                object: nil,
            //                userInfo: ["statusText": "Signed in user:\n\(fullName)"])
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    //MARK: - did Register for Remote Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DEVICE TOKEN = \(deviceToken.description)")
        var token = NSString(format: "%@", deviceToken as CVarArg)
        token = token.replacingOccurrences(of: "<", with: "") as NSString
        token = token.replacingOccurrences(of: ">", with: "") as NSString
        token = token.replacingOccurrences(of: " ", with: "") as NSString
        UserDefaults.standard.set(token as String, forKey: "deviceToken")
        print("device token saved=\(token)")
        
        //let uuid = NSUUID().uuidString
        //UserDefaults.standard.set(uuid, forKey: "UUID")
        //print("UUID:\(uuid)")
        
        //<fb2966f1 33905843 ca914a17 52144cf1 42d98819 532c6a3b 8b74dc98 09e497b7>
        //fb2966f133905843ca914a1752144cf142d98819532c6a3b8b74dc9809e497b7
        //<0a68af45 3729a298 f56aa95c 861347e7 260e6303 3de20986 be6cdbc2 aa5f827a>
        //0a68af453729a298f56aa95c861347e7260e63033de20986be6cdbc2aa5f827a
        //let notificationName = Notification.Name("registerDeviceToken")
        //NotificationCenter.default.post(name: notificationName, object: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error as Any)
    }
    
    //MARK: - did Receive Remote Notification
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
         print("Recived: \(userInfo)")
    }
    
    private func application(application: UIApplication,  didReceiveRemoteNotification userInfo: [NSObject : AnyObject],  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:userInfo.description , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        print("Recived: \(userInfo)")
        //completionHandler(.newData)
    }

    //MARK: - Push Notification for iOS 9 and earlier
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Recived: \(userInfo)")
        
        let data = userInfo["data"] as? NSDictionary
        let code:Int = data!["code"] as! Int
        // let details = data?["details"] as? NSDictionary
        //let tripid = details?["tripid"] as? Int
        //let driverid:Int = (details!["driverid"] as? Int)!
        //  ["data"]["code"]
        
        //let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        //UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        //registerNotification()
        
        switch code{
            
        case 102:
            scheduleNotification(alertBody: "سفر توسط راننده تایید شد.")
            let notificationName = Notification.Name("event102")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 103:
            scheduleNotification(alertBody: "هیچ راننده ای برای سفر یافت نشد.")
            let notificationName = Notification.Name("event103")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 104:
            scheduleNotification(alertBody: "راننده نزدیک مبدا رسیده است.")
            let notificationName = Notification.Name("event104")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 106:
            scheduleNotification(alertBody: "بسته در مبدا تحویل گرفته شد.")
            let notificationName = Notification.Name("event106")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 107:
            scheduleNotification(alertBody: "بسته در مقصد تحویل داده شد.")
            // let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 108:
            scheduleNotification(alertBody: "بسته در مقصد تحویل گرفته شد.")
            //let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 109:
            scheduleNotification(alertBody: "بسته درمبدا تحویل داده شد.")
            //let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 111:
            scheduleNotification(alertBody: "سفر توسط راننده لغو گردید.")
            let notificationName = Notification.Name("event111")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        case 112:
            scheduleNotification(alertBody: "سفر به اتمام رسید.")
            let notificationName = Notification.Name("event112")
            NotificationCenter.default.post(name: notificationName, object: userInfo)
            break
        default:
            print("default\n")
        }
    }
    //MARK: - application Delegate
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //set badge to zero
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //set badge to zero
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Push Notification for iOS 10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Called to let your app know which action was selected by the user for a given notification.
        print(response.notification.request.content.userInfo)
        print(response.notification.request.content.userInfo["data"] as Any)
        
        let Dic = response.notification.request.content.userInfo["data"] as? NSDictionary
        if Dic == nil {
            return;
        }
        let code:Int = Dic!["code"] as! Int
        
        //registerNotification()
        
        switch code{
        case 102:
            scheduleNotification(alertBody: "سفر توسط راننده تایید شد")
            let notificationName = Notification.Name("event102")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 103:
            scheduleNotification(alertBody: "هیچ راننده ای برای سفر یافت نشد.")
            let notificationName = Notification.Name("event103")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 104:
            scheduleNotification(alertBody: "راننده نزدیک مبدا رسیده است.")
            let notificationName = Notification.Name("event104")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 106:
            scheduleNotification(alertBody: "بسته در مبدا تحویل گرفته شد.")
            let notificationName = Notification.Name("event106")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 107:
            scheduleNotification(alertBody: "بسته در مقصد تحویل داده شد.")
            //let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 108:
            scheduleNotification(alertBody: "بسته در مقصد تحویل گرفته شد.")
            //let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 109:
            scheduleNotification(alertBody: "بسته در مبدا تحویل داده شد.")
            //let notificationName = Notification.Name("showAlert")
            //NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 111:
            scheduleNotification(alertBody: "سفر توسط راننده لغو گردید.")
            let notificationName = Notification.Name("event111")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        case 112:
            scheduleNotification(alertBody: "سفر به اتمام رسید.")
            let notificationName = Notification.Name("event112")
            NotificationCenter.default.post(name: notificationName, object: Dic)
            break
        default:
            print("default\n")
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Called when a notification is delivered to a foreground app.
        
        //print(notification.request.content.userInfo)
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
        //print(notification.request.content.userInfo["data"])
    }
    
    //MARK: - Local Notification
    
//    func registerNotification() {
//        
//        if #available(iOS 10.0, *) {
//            scheduleLocalNotification10((Calendar.current as NSCalendar).components([NSCalendar.Unit.hour, NSCalendar.Unit.minute], from: Date()), category: "")
//        } else {
//            scheduleLocalNotification(Date(), category: "")
//        }
//    }
    
    func registerNotification() {
        
        let settings = UIUserNotificationSettings(types: [.alert,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
     ////Schedule the Notifications with repeat
    func scheduleNotification(alertBody:String) {
    //UIApplication.sharedApplication().cancelAllLocalNotifications()
    // Schedule the notification ********************************************
    //if UIApplication.shared.scheduledLocalNotifications?.count == 0 {
        print(UIApplication.shared.scheduledLocalNotifications?.count as Any)
        let notification = UILocalNotification()
        notification.alertBody = alertBody
        notification.soundName = UILocalNotificationDefaultSoundName
        //notification.fireDate = Date()
        
        //UIApplication.shared.scheduleLocalNotification(notification)
        UIApplication.shared.presentLocalNotificationNow(notification)
        // }
    }
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//        scheduleNotification(alertBody: "سفر بخیر")
//    }

//    @available(iOS 10.0, *)
//    func scheduleLocalNotification10(_ dateComp : DateComponents, category : String) {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//            if granted {
//                center.removeDeliveredNotifications(withIdentifiers: [category])
//                let content = UNMutableNotificationContent()
//                content.body = "Driver Accept Trip"
//                content.sound = UNNotificationSound.default()
////                if AppSettings.load(AppSettings.Constants.isDefaultToneKey) as! Bool {
////                    content.sound = UNNotificationSound.default()
////                } else {
////                    content.sound = UNNotificationSound.init(named: "my_sound.mp3")
////                }
//                let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComp, repeats: true)
//                let request = UNNotificationRequest(identifier: category, content: content, trigger: trigger)
//                center.add(request)
//            }
//        }
//    }
//
//    func scheduleLocalNotification(_ fireDate : Date, category : String) {
//        
//        let agendaLocalNotification = UILocalNotification()
//        agendaLocalNotification.timeZone = TimeZone.autoupdatingCurrent
//        agendaLocalNotification.fireDate = fireDate
//        agendaLocalNotification.alertBody = "Driver Accept Trip"
//        //agendaLocalNotification.repeatInterval = .day
//        agendaLocalNotification.category = category
//        agendaLocalNotification.soundName = UILocalNotificationDefaultSoundName
//        
////        if AppSettings.load(AppSettings.Constants.isDefaultToneKey) as! Bool {
////            agendaLocalNotification.soundName = UILocalNotificationDefaultSoundName
////        } else {
////            agendaLocalNotification.soundName = "my_sound.mp3"
////        }
//        
//        UIApplication.shared.scheduleLocalNotification(agendaLocalNotification)
//    }
    
    //MARK: - uncaughtExceptionHandler
    let uncaughtExceptionHandler : Void = NSSetUncaughtExceptionHandler { exception in
        NSLog("Name:" + exception.name.rawValue)
        if exception.reason == nil
        {
            NSLog("Reason: nil")
        }
        else
        {
            NSLog("Reason:" + exception.reason!)
        }
    }
}

