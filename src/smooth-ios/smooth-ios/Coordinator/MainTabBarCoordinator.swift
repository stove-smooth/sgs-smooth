//
//  MainTabBarCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/13.
//

import UIKit

class MainTabBarCoordinator: NSObject, Coordinator {
    
    enum TabBarItem: CaseIterable {
        case home
        case friend
        case search
        case mention
        case profile
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .friend: return "친구"
            case .search: return "검색"
            case .mention: return "멘션"
            case .profile: return "나"
            }
        }
        
        var image: String {
            switch self {
            case .home: return "TabBar+Logo"
            case .friend: return "TabBar+Friend"
            case .search: return "TabBar+Search"
            case .mention: return "TabBar+Mension"
            case .profile: return "TabBar+Friend"
            }
        }
        
        func getCoordinator(navigationController: UINavigationController) -> Coordinator {
            switch self {
            case .home: return HomeCoordinator(navigationController: navigationController)
            case .friend: return FriendCoordinator(navigationController: navigationController)
            case .search: return HomeCoordinator(navigationController: navigationController)
            case .mention: return HomeCoordinator(navigationController: navigationController)
            case .profile: return HomeCoordinator(navigationController: navigationController)
            }
        }
    }
    
    var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController
    var tabBarItems: [TabBarItem] = [.home, .friend, .search, .mention, .profile]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = .white
        self.navigationController.navigationBar.barTintColor = UIColor.backgroundDarkGray
        self.navigationController.navigationBar.shadowImage = UIImage()
        self.navigationController.navigationBar.isTranslucent = false
        
        self.navigationController.setNavigationBarHidden(true, animated: true)
        
        self.childCoordinators = []
        self.tabBarController = UITabBarController()
        
        self.tabBarController.tabBar.backgroundColor = UIColor(hex: "0x18191C")
        self.tabBarController.tabBar.tintColor = .white
    }
    
    func start() {
        let controllers = tabBarItems.map { getTabController(item: $0) }
        prepareTabBarController(withTabControllers: controllers)
        
        getTabController(item: .home)
    }
    
    func getTabController(item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabItem = UITabBarItem(title: item.title, image: UIImage(named: item.image), selectedImage: UIImage(named: "\(item.image)-selected"))
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
        
        return navigationController
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = 0
        tabBarController.tabBar.isTranslucent = true
        navigationController.viewControllers = [tabBarController]
    }
    
}
