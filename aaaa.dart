import UIKit
import Flutter
//import SwiftyJSON

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var secureManager: SecureManager?

    var loginRetry: Int = 0
    var syncPublicKeyRetry: Int = 0

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerForPushNotifications()

        self.secureManager = SecureManager();

        GeneratedPluginRegistrant.register(with: self)
        weak var registrar = self.registrar(forPlugin: "plugin-name")

//        let factory = FLNativeViewFactory(messenger: registrar!.messenger())
//        self.registrar(forPlugin: "<plugin-name>")!.register(
//            factory,
//            withId: "nativeView")

        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
                
        let storageChannel = FlutterMethodChannel(name: "com.sgx.SGX/native",
                                                  binaryMessenger: controller.binaryMessenger)
        storageChannel.setMethodCallHandler { (call, result) in
            if call.method == "getIOSCredentials" {
                guard let secureManager = self.secureManager else {
                    print("secureManager is nil")
                    result(FlutterError(code: "UNAVAILABLE", message: "SecureManager not initialized", details: nil))
                    return
                }
                guard let privateKey = secureManager.exportCleanPrivateKeyToPKCS1() else {
                    print("privateKey is nil")
                    result(FlutterError(code: "UNAVAILABLE", message: "Private key not available", details: nil))
                    return
                }
                guard let userId = secureManager.getUserId() else {
                    print("userId is nil")
                    result(FlutterError(code: "UNAVAILABLE", message: "User ID not available", details: nil))
                    return
                }
                guard let deviceToken = secureManager.getDeviceToken() else {
                    print("deviceToken is nil")
                    result(FlutterError(code: "UNAVAILABLE", message: "Device token not available", details: nil))
                    return
                }

                    let prefs = [
                        "SYNC_PUB_KEY": privateKey,
                        "DEVICE_ID": deviceToken,
                        "USER_ID": userId,
                        "PUSH_TOKEN": self.retrievePushToken() ?? "",
                    ] as [String : Any]
                    result(prefs)
                result(FlutterMethodNotImplemented)
            }  else if call.method == "getPushToken" {
                let prefs = [
                    "PUSH_TOKEN": self.retrievePushToken() ?? "",
                ] as [String : Any]
                result(prefs);
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let allowedBundleIDs: Set<String> = []
           guard let sourceApp = options[.sourceApplication] as? String, allowedBundleIDs.contains(sourceApp) else {
               print("Untrusted source application: \(String(describing: options[.sourceApplication]))")
               return false
           }
           guard let scheme = url.scheme, scheme == "sgxmobile" else {
               return false
           }
        return true
    }

    
    class func showRequestError(_ message: String, title: String = "Error") {
         // Ensure we have the correct AppDelegate instance
         guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             return
         }
         
         // Main thread check as UI updates must be on the main thread
         DispatchQueue.main.async {
             let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
             let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
             alertController.addAction(okAction)
             
             // Presenting on the rootViewController
             if let rootVC = appDelegate.window?.rootViewController {
                 // If the rootViewController is presenting another view controller, present the alert on that one
                 var currentVC = rootVC
                 while let presentedVC = currentVC.presentedViewController {
                     currentVC = presentedVC
                 }
                 currentVC.present(alertController, animated: true, completion: nil)
             }
         }
     }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert binary device token to a string
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "pushNotificationToken")
        UserDefaults.standard.synchronize() // This line is optional as UserDefaults automatically synchronizes data periodically.

        // Send the token to Flutter
//        sendPushTokenToFlutter(token)
    }
    
    func updatePushToken() {
        if let pushToken = UserDefaults.standard.object(forKey: "pushNotificationToken") as? String {
            sendPushTokenToFlutter(pushToken)
        }
    }
    
    func retrievePushToken() -> String? {
        return UserDefaults.standard.string(forKey: "pushNotificationToken")
    }

    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Handle failure to receive push token
        print("Failed to register: \(error)")
    }

    func sendPushTokenToFlutter(_ token: String) {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return
        }
        let channel = FlutterMethodChannel(name: "com.sgx.online/token", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("saveToken", arguments: token)
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication){
        updatePushToken()
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        tabNotification(payload: response.notification.request.content.userInfo)
        
        // Call the completion handler
        completionHandler()
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification while the app is in the foreground
        // For example, show an alert or play a sound
        receividNotification(payload: notification.request.content.userInfo)
        completionHandler([.alert, .sound, .badge])
    }
    // Send payload to Flutter
        func receividNotification(payload: [AnyHashable: Any]) {
            if let controller = window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(name: "com.sgx.notifications", binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod("onNotificationReceived", arguments: payload)
            }
        }
    
    func tabNotification(payload: [AnyHashable: Any]) {
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.sgx.notifications", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("onNotificationTap", arguments: payload)
        }
    }

}

