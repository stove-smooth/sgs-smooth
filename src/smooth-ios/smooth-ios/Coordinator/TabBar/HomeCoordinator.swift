//
//  HomeCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/13.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let homeVC = HomeViewController.instance()
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func goToContainer() {
        let vc = ContainerViewController.instance()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
