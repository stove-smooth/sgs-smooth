//
//  FriendCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit
import PanModal

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
        let friendVC = FriendListViewController.instance()
        friendVC.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(friendVC, animated: true)
    }
    
    func goToRequest() {
        let requestVC = FriendRequestViewController.instance()
    
        requestVC.modalPresentationStyle = .fullScreen
        navigationController.present(requestVC, animated: true, completion: nil)
    }
    
    func showFriendInfoModal(friend: Friend) {
        let friendInfoVC = FriendInfoViewController.instance(friend: friend)
        
        navigationController.presentPanModal(friendInfoVC)
    }
}
