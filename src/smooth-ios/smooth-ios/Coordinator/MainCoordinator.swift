//
//  MainCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class MainCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    let window: UIWindow
    
    //    init(navigationController: UINavigationController) {
    //        self.navigationController = navigationController
    //        self.navigationController.navigationBar.tintColor = .white
    //
    //        self.navigationController.navigationBar.barTintColor = UIColor.backgroundDartGray
    //        self.navigationController.navigationBar.shadowImage = UIImage()
    //        self.navigationController.navigationBar.isTranslucent = false
    //    }
    
    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barTintColor = UIColor.backgroundDartGray
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        
        navigationController.setNavigationBarHidden(true, animated: true)
        
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        window.rootViewController = navigationController
        
        let token = UserDefaultsUtil.getUserToken()
        
        if token == nil {
            // 로그인이 안되어 있는 경우
            let vc = SplashViewConroller.instance()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        } else {
            self.goToMain()
        }
        
        window.makeKeyAndVisible()
    }
    
    func goToSigIn() {
        let vc = SignInViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMain() {
        let coordinator = MainTabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        
        coordinator.start()
    }
    
    func goToSignUp() {
        let vc = SignUpViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSignUpInfo() {
        let vc = SignUpInfoViewController.instance()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToVerifyCode() {
        let vc = VerifyCodeViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
