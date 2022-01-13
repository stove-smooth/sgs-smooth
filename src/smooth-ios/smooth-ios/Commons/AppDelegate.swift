import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: MainCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        coordinator = MainCoordinator(window: window!)
        coordinator?.start()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
    
    
    func goToMain() {
            window?.rootViewController = HomeViewController.instance()
            window?.makeKeyAndVisible()
        }
        
    func goToSignIn() {
            window?.rootViewController = SignInViewController.instance()
            window?.makeKeyAndVisible()
    }
}
