//
//  FriendCoordinator.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit

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
        let friendVC = FriendViewController.instance()
        friendVC.coordinator = self
        navigationController.pushViewController(friendVC, animated: true)
        
        // TODO: - 1개의 뷰에서 테이블뷰로 하기
//        FriendRepository.fetchFriend { [self] friends, _ in
//            guard let friends = (friends as [Friend]? ) else {
//                print("FriendRepository.fetchFriend error")
//                return
//            }
//            if friends.count == 0 {
//                let emptyVC = FriendEmptyViewController.instance()
//                emptyVC.coordinator = self
//                navigationController.pushViewController(emptyVC, animated: true)
//            } else {
//                let friendVC = FriendViewController.instance()
//                friendVC.coordinator = self
//                friendVC.friends = friends
//                navigationController.pushViewController(friendVC, animated: true)
//            }
//        }
    }
    
    func goToRequest() {
        let requestVC = FriendRequestViewController.instance()
        requestVC.coordinator = self
        navigationController.present(requestVC, animated: true, completion: nil)
    }
}
