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
    
    func start() {
        let homeVC = HomeViewController.instance()
        homeVC.coordinator = self
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(homeVC, animated: true)
    }
    
    func goToContainer() {
        let vc = ContainerViewController.instance()
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
    
    func showServerInfoModal(server: Server, member: Member) {
        let serverInfoVC = ServerInfoViewController.instance(server: server, member: member)
        serverInfoVC.coordinator = self
        
        navigationController.presentPanModal(serverInfoVC)
    }
    
    func goToEditServerInfo(server: Server) {
        let editVC = EditServerInfoViewController.instance(server: server)
        
        editVC.modalPresentationStyle = .fullScreen
        navigationController.present(editVC, animated: true, completion: nil)
    }
}
