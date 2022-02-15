//
//  MainCoordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

class MainCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorDelegate?
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController().setup
        navigationController.setNavigationBarHidden(true, animated: true)
        
        self.navigationController = navigationController
        self.childCoordinators = []
    }
    
    func start() {
        window.rootViewController = navigationController
        
        let token = UserDefaultsUtil.getUserToken()
        
        if token == nil {
            // 로그인이 안되어 있는 경우
            self.goToSplast()
        } else {
            self.goToMain()
        }
        
        window.makeKeyAndVisible()
    }
    
    func goToSplast() {
        let coordinator = SplashCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func goToMain() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
}
