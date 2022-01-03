//
//  MainCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SplashViewConroller.instance()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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
