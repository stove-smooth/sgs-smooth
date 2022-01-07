//
//  MainCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class MainCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .white
        
        self.navigationController.navigationBar.barTintColor = UIColor.backgroundDartGray
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = false
        
    }
    
    func start() {
        let token = UserDefaultsUtil.getUserToken()
        
        if token == nil {
            // 로그인이 안되어 있는 경우
            let vc = SplashViewConroller.instance()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        } else {
            self.goToMain()
        }
        
    }
    
    func goToSigIn() {
        let vc = SignInViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMain() {
        let vc = HomeViewController.instance()
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
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
