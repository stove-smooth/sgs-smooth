//
//  AddServerCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit

class AddServerCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var modalNav: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.modalNav = UINavigationController()
        self.navigationController = navigationController
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.tabBarController?.tabBar.isHidden = true
        
        self.modalNav.navigationBar.tintColor = .white
        self.modalNav.navigationItem.backButtonDisplayMode = .minimal
        self.modalNav.navigationBar.isTranslucent = false
        self.modalNav.navigationBar.shadowImage = UIImage()
        self.modalNav.navigationBar.barTintColor = .backgroundDarkGray
        
        self.childCoordinators = []
    }
    
    func start() {
        let addServerVC = AddServerViewController.instance()
        addServerVC.coordinator = self
        
        modalNav.pushViewController(addServerVC, animated: true)
        modalNav.modalPresentationStyle = .fullScreen
        modalNav.isNavigationBarHidden = true
        
        navigationController.present(modalNav, animated: true, completion: nil)
    }
    
    func goToJoin() {
        let joinVC = JoinServerViewController.instance()
        joinVC.coordinator = self
        
        modalNav.isNavigationBarHidden = false
        modalNav.pushViewController(joinVC, animated: true)
    }
    
    func goToMake() {
        let makeVC = MakeServerViewContrller.instance()
        makeVC.coordinator = self
        
        modalNav.isNavigationBarHidden = false
        modalNav.pushViewController(makeVC, animated: true)
    }
    
    func goToRegister(isPrivate: Bool) {
        let registerVC = RegisterServerViewController.instance(isPrivate: isPrivate)
        registerVC.coordinator = self
        
        modalNav.isNavigationBarHidden = false
        modalNav.pushViewController(registerVC, animated: true)
    }
    
    func goToInvite(serverId: Int) {
        let inviteVC = InviteServerViewController.instance(serverId: serverId)
        
        inviteVC.coordinator = self
        modalNav.isNavigationBarHidden = true
        modalNav.pushViewController(inviteVC, animated: true)
    }
}
