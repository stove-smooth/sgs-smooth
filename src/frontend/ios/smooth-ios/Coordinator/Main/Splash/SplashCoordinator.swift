//
//  SplashCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import UIKit

class SplashCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.navigationController.tabBarController?.tabBar.setUpUITabBar()
        
        
    }
    
    func start() {
        let SplashVC = SplashViewConroller.instance()
        SplashVC.coordinator = self
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(SplashVC, animated: false)
    }
    
    func goToSigIn() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let deviceToken = appDelegate.deviceToken
        
        let vc = SigninViewController.instance(deviceToken: deviceToken!)
        vc.coordinator = self
        navigationController.removeFromParent()
        navigationController.pushViewController(vc, animated: true)
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
    
    func goToMain() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start(communityId: nil, channelId: nil)
    }
}
