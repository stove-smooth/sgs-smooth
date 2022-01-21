//
//  FriendCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit

class FriendCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        navigationController.navigationBar.backgroundColor = .backgroundDarkGray
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barTintColor = .backgroundDarkGray
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let friendVC = FriendViewController.instance()
        friendVC.coordinator = self
        navigationController.pushViewController(friendVC, animated: true)
    }
    
    func goToRequest() {
        let requestVC = FriendRequestViewController.instance()
        navigationController.present(requestVC, animated: true, completion: nil)
    }
}
