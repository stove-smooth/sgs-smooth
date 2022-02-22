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
    }

    func start(communityId: Int?, channelId: Int?) {
        
        let homeVC = HomeViewController.instance(communityId: communityId, channelId: channelId)
        homeVC.coordinator = self
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(homeVC, animated: false)
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
    
    func showFriendInfoModal(id: Int, state: FriendState) {
        let friendInfoVC = FriendInfoViewController.instance(userId: id, state: state)
        
        navigationController.presentPanModal(friendInfoVC)
    }
    
    func goToProfile() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.delegate = self
        
        coordinator.start()
    }
    
    func goToInfo(isGroup: Bool, id: Int) {
        let infoVC = InfoViewController.instance(isGroup: isGroup, id: id)
        infoVC.coordinator = self
        
        navigationController.pushViewController(infoVC, animated: true)
    }
}
