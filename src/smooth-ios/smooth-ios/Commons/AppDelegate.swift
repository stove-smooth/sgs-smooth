import UIKit
import RxSwift
import StompClientLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var coordinator: MainCoordinator?
    var window: UIWindow?
    var socket: ChatWebSocketServiceProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        socket = ChatWebSocketService()
        
        RxImagePickerDelegateProxy.register { RxImagePickerDelegateProxy(imagePicker: $0) }
        socket?.register()
        socket?.connect(type: "group", channelId: 105)
        socket?.connect(type: "direct", channelId: nil)
        
        
        coordinator = MainCoordinator(window: window!)
        coordinator?.start()
        
        return true
    }
    
    // active -> inactive로 이동될 때
    func applicationWillResignActive(_ application: UIApplication) {}
    
    // 백그라운드 상태일 때
    func applicationDidEnterBackground(_ application: UIApplication) {
        socket?.disconnect()
    }
    
    // 백그라운드 -> 포그라운드
    func applicationWillEnterForeground(_ application: UIApplication) {}
    
    // active(실행중)
    func applicationDidBecomeActive(_ application: UIApplication) {
//        socket?.autoReconnect()
    }
    
    // 앱 종료
    func applicationWillTerminate(_ application: UIApplication) {
        socket?.disconnect()
    }
}
