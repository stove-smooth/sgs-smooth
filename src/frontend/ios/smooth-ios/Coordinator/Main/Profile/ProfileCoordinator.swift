//
//  ProfileCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import UIKit

class ProfileCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        let profileVC = ProfileViewController.instance()
        profileVC.coordinator = self
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(profileVC, animated: false)
    }
    
    func goToMain() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start(communityId: nil, channelId: nil)
    }
    
    func goToFriend() {
        let coordinator = FriendCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToEdit(user: User) {
        let editVC = EditProfileViewController.instance(user: user)
        editVC.coordinator = self
        
        navigationController.pushViewController(editVC, animated: true)
    }
    
    func goToLoginHome() {
        let coordinator = SplashCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
