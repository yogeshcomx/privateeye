//
//  AppDelegate.swift
//  PrivateInvestigator
//
//  Created by apple on 6/19/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import IQKeyboardManagerSwift
import Reachability
import GoogleMaps
import GooglePlacePicker
import CoreLocation
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    let reachability = Reachability()!
    let locationManager = CLLocationManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        
        loadAppBasedOnUserStatus()
        loadCountries()
        loadCaseTypes()
        loadTipsTypes()
        loadRulesTypes()
        loadCaseLiveStatusOptions()
        setupLocationManager()
        GMSPlacesClient.provideAPIKey("AIzaSyC9fPCTskN0ybo8KpdT7By3ql8scr3lqu4")
        GMSServices.provideAPIKey("AIzaSyDsC5JgwQWx_jwvLxk_6AFoE0HnHuHwbeA")
        GIDSignIn.sharedInstance().clientID = "119134661755-7bo68a8i11s26pfkl6mi5p4vshbcud8c.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self as? MessagingDelegate
            addActionAndSetCategoryForNotifications()
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        UserDefaults.standard.set(fcmToken, forKey: fcmTokenUserDefaults)
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
        print("HI")
        let bodyMessage:String =  notification.request.content.body
        print(bodyMessage)
        
    }
    
    func addActionAndSetCategoryForNotifications() {
        // 1
        let acceptAction = UNNotificationAction(identifier: "AcceptCase",
                                              title: "Accept",
                                              options: [])
        let rejectAction = UNNotificationAction(identifier: "RejectCase",
                                                title: "Reject",
                                                options: [])
        
        // 2
        let newCaseCategory = UNNotificationCategory(identifier: "NewCaseCategory",
                                                  actions: [acceptAction,rejectAction],
                                                  intentIdentifiers: [],
                                                  options: [])
        // 3
        UNUserNotificationCenter.current().setNotificationCategories([newCaseCategory])

    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let message = userInfo as NSDictionary
        print(message)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "AcceptCase" {
        } else if response.actionIdentifier == "RejectCase" {
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        let categoryCase = userInfo["category"] as! String
        
        print(":::::::::::: \(userInfo) ::::::::::::")
        
        
        if categoryCase == "AcceptCase" {

        }

        
        let message = userInfo as NSDictionary
        print(message)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        print("OOOOOOOOOOOOOOOOOOOOOOOO")
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
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let fbHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let googleHandle = GIDSignIn.sharedInstance().handle(url as URL?,
                                                             sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                             annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return googleHandle || fbHandle
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: googleSignInNotification), object: nil, userInfo: ["result" : false])
        } else {
            let userId:String = user.userID
            let idToken:String = user.authentication.idToken
            let fullName:String = user.profile.name
            let givenName:String = user.profile.givenName
            let familyName:String = user.profile.familyName
            let email:String = user.profile.email
            let imageUrl:String = user.profile.imageURL(withDimension: 100).absoluteString
            let userDetailsDictionary: [String:String] = ["FirstName": givenName, "LastName": familyName, "Gender": "", "DOB" : "", "GoogleID": userId, "FacebookID": "", "Email": email, "Phone": "", "Countrycode" : "", "ProfilePicUrl" : imageUrl, "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "" , "Longitude" : ""]
            UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: googleSignInNotification), object: nil, userInfo: ["result" : true])
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: googleSignInNotification), object: nil, userInfo: ["result" : false])
    }
    
    
    func loadAppBasedOnUserStatus() {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Booker", bundle: nil)
//        let initialViewController = storyboard.instantiateInitialViewController()
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
        if UserDefaults.standard.bool(forKey: userLoginStatusUserDefaults) == true {
            if UserDefaults.standard.integer(forKey: userRoleIdUserDefaults) == 1 {
                let registrationFlow:String = UserDefaults.standard.string(forKey: registrationFlowStatusUserDefaults) ?? ""
                switch registrationFlow {
                case registeredSignUpFlowValue : loadViewController(storyBoard: "Main", viewController: "GeneralSignUp")
                case phoneNumberVerifiedSignUpFlowValue : loadViewController(storyBoard: "Main", viewController: "BookerRegistration")
                case profileUpdatedSignUpFlowValue : loadViewController(storyBoard: "Booker", viewController: nil)
                case paymentDoneSignUpFlowValue : loadViewController(storyBoard: "Booker", viewController: nil)
                case completedSignUpFlowValue : loadViewController(storyBoard: "Booker", viewController: nil)
                default : loadViewController(storyBoard: "Main", viewController: nil)
                }
            } else if UserDefaults.standard.integer(forKey: userRoleIdUserDefaults) == 2 {
                let registrationFlow:String = UserDefaults.standard.string(forKey: registrationFlowStatusUserDefaults) ?? ""
                switch registrationFlow {
                case registeredSignUpFlowValue : loadViewController(storyBoard: "Main", viewController: "GeneralSignUp")
                case phoneNumberVerifiedSignUpFlowValue : loadViewController(storyBoard: "Main", viewController: "PrivateInvestigatorRegistration")
                case profileUpdatedSignUpFlowValue : loadViewController(storyBoard: "Main", viewController: "PaymentPIRegistration")
                case paymentDoneSignUpFlowValue : loadViewController(storyBoard: "PrivateInvestigator", viewController: nil)
                case completedSignUpFlowValue : loadViewController(storyBoard: "PrivateInvestigator", viewController: nil)
                default : loadViewController(storyBoard: "Main", viewController: nil)
                }
            }
        }
    }
    
    func loadViewController(storyBoard:String, viewController:String?) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: storyBoard, bundle: nil)
        var initialViewController = UIViewController()
        if viewController != nil {
            initialViewController = storyboard.instantiateViewController(withIdentifier: viewController!)
        } else {
            initialViewController = storyboard.instantiateInitialViewController()!
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    
    func checkNetworkStatus() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        let reachable = Reachability()
        switch reachable!.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            let alert = UIAlertController(title: "No Internet", message: "Please check your network connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { _ in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(settingsUrl)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            let alert = UIAlertController(title: "No Internet", message: "Please check your network connection", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { _ in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(settingsUrl)
                }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadCountries() {
        APIManager.sharedInstance.getCountryCodeList(onSuccess: { countries in
            countriesListGlobal = countries
        }, onFailure: { error in
            print(error)
        })
        
    }
    
    func loadCaseTypes() {
        APIManager.sharedInstance.getCaseTypeList(onSuccess: { casetypes in
            caseTypesListGlobal = casetypes
        }, onFailure: { error in
            print(error)
        })
    }
    
    func loadCaseLiveStatusOptions() {
        APIManager.sharedInstance.getCaseLiveStatusOptionsList(onSuccess: { caseLiveStatusOptions in
            caseLiveStatusFeedOptionsGlobal = caseLiveStatusOptions
        }, onFailure: { error in
            print(error)
        })
    }
    
    func loadTipsTypes() {
        APIManager.sharedInstance.getTipsListList(onSuccess: { tipsList in
            tipsListGlobal = tipsList
        }, onFailure: { error in
            print(error)
        })
    }
    
    func loadRulesTypes() {
        APIManager.sharedInstance.getRulesList(onSuccess: { rulesList in
            rulesListGlobal = rulesList
        }, onFailure: { error in
            print(error)
        })
    }
    
    func setupLocationManager() {
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            let alert = UIAlertController(title: "Turn on Location", message: "Please go to Settings and turn on the location permissions and try again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { _ in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
                UIApplication.shared.open(settingsUrl)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func endLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    
    
//    func scheduleNotification() {
//        let calendar = Calendar(identifier: .gregorian)
//        print(Date())
//        print(Date().addingTimeInterval(1*30))
//        let components = calendar.dateComponents(in: .current, from: Date().addingTimeInterval(1*60))
//        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
//
//        let content = UNMutableNotificationContent()
//        content.title = "Private Eye - New Case"
//        content.body = "Mumbai Central | Cheating partner | 7.30pm 10/10/2018 | Fess IN $ 85.00"
//        content.sound = UNNotificationSound.default()
//        content.categoryIdentifier = "NewCaseCategory"
//
//        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().delegate = self
//        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().add(request) {(error) in
//            if let error = error {
//                print("Uh oh! We had an error: \(error)")
//            }
//        }
//    }
    
}


extension AppDelegate : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        let userId:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        APIManager.sharedInstance.putUpdateUserCurrentLocation(userid: userId, onSuccess: { status in
            if status {
                
            } else {
                self.locationManager.startUpdatingLocation()
            }
        }, onFailure: { error  in
            self.locationManager.startUpdatingLocation()
        })
        if UserDefaults.standard.bool(forKey: userLoginStatusUserDefaults) == true {
            if UserDefaults.standard.integer(forKey: userRoleIdUserDefaults) == 1 {
                endLocationManager()
            }
        }
    }
}

