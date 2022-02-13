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
    
    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController().setup
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
        let vc = SigninViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMain() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToSignUp() {
        let vc = SignupViewController.instance()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSignUpInfo(email: String) {
        let vc = SignupInfoViewController.instance(email: email)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToVerifyCode(email: String) {
        let vc = VerifyCodeViewController.instance(email: email)
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
