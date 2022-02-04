//
//  HomeCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/13.
//

import UIKit
import PanModal

class HomeCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = []
        self.navigationController.tabBarController?.tabBar.setUpUITabBar()
    }
    
    func start() {
        let homeVC = HomeViewController.instance()
        homeVC.coordinator = self
        
        navigationController.tabBarController?.tabBar.setUpUITabBar()
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func goToContainer() {
        let vc = ChattingViewController.instance()
        let homeVC = HomeViewController.instance()
        
        vc.coordinator = self
        
        vc.didMove(toParent: homeVC)
    }
    
    func goToMenu() {
        let vc = MenuViewController.instance()
        let homeVC = HomeViewController.instance()
        
        vc.coordinator = self
        vc.didMove(toParent: homeVC)
    }
    
    func goToAddServer() {
        let coordinator = AddServerCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToFriend() {
        let coordinator = FriendCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showServerInfoModal(server: Server, member: Member) {
        let serverInfoVC = ServerInfoViewController.instance(server: server, member: member)
        serverInfoVC.coordinator = self
        
        navigationController.presentPanModal(serverInfoVC)
    }
    
    func goToServerSetting(server: Server) {
        let coordinator = ServerSettingCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start(server: server)
    }
    
    func showMakeChannel(categoryId: Int) {
        let makeChannelVC = MakeChannelViewController.instance(categoryId: categoryId)
        makeChannelVC.coordinator = self
        
        navigationController.present(makeChannelVC, animated: true, completion: nil)
    }
    
    func showMakeCategory(server: Server) {
        let makeCategoryVC = MakeCategoryViewController.instance(server: server)
        makeCategoryVC.coordinator = self
        
        navigationController.present(makeCategoryVC, animated: true, completion: nil)
    }
    
    func showFriendInfoModal(friend: Friend) {
        let friendInfoVC = FriendInfoViewController.instance(friend: friend)
        
        navigationController.presentPanModal(friendInfoVC)
    }
}
