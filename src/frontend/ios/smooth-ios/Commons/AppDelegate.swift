import UIKit
import RxSwift
import StompClientLib
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: MainCoordinator?
    var window: UIWindow?
    var deviceToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        FirebaseApp.configure()
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        coordinator = MainCoordinator(window: window!, deviceToken: "")
        coordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // active -> inactive로 이동될 때
    func applicationWillResignActive(_ application: UIApplication) {}
    
    // 백그라운드 상태일 때
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    // 백그라운드 -> 포그라운드
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    // active(실행중)
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    // 앱 종료
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
        
        self.deviceToken = fcmToken
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 포그라운드 (todos: 로컬 노티 처리)
        
        let userInfo = notification.request.content.userInfo
        let receiveData = userInfo["aps"] as! [String:AnyObject]
        
        let channelId = receiveData["channelId"] as? String
        let communityId = receiveData["communityId"] as? String
        
        print(channelId!)
        print(communityId!)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        // 백그라운드 노티 수신 시 클릭하면 실행되는 핸들러
        // coordinator 처리 해야함
        
        let userInfo = response.notification.request.content.userInfo
    
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
        print(response)

        completionHandler()
      }
}
