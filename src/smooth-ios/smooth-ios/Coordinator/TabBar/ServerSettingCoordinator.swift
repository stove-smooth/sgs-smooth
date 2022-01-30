//
//  ServerSettingCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerSettingCoordinator: NSObject, Coordinator {
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
    
    func start(server: Server) {
        let settingVC = ServerSettingViewController.instance(server: server)
        settingVC.coordinator = self
        
        modalNav.modalPresentationStyle = .fullScreen
        modalNav.isNavigationBarHidden = true
        
        navigationController.present(modalNav, animated: true, completion: nil)
        modalNav.pushViewController(settingVC, animated: true)
    }
    
    func goToMain() {
        self.coordinatorDidFinish()
        
        
        navigationController.popToRootViewController(animated: true)
//        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func goToEditServerInfo(server: Server) {
        let editVC = EditServerInfoViewController.instance(server: server)
        
        modalNav.isNavigationBarHidden = false
        navigationController.isNavigationBarHidden = true
        modalNav.pushViewController(editVC, animated: true)
    }
    
}
