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
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let friendVC = FriendListViewController.instance()
        friendVC.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(friendVC, animated: false)
    }
    
    func goToMain() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToProfile() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToRequest() {
        let requestVC = FriendRequestViewController.instance()
        
        requestVC.modalPresentationStyle = .fullScreen
        navigationController.present(requestVC, animated: true, completion: nil)
    }
    
    func showFriendInfoModal(id: Int, state: FriendState) {
        let friendInfoVC = FriendInfoViewController.instance(friendId: id, state: state)
        
        navigationController.presentPanModal(friendInfoVC)
    }
}
