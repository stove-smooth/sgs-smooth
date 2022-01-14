//
//  Coordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit

protocol CoordinatorDelegate {
    func coordinatorDidFinish()
    func removeChildCoordinator(_ coordinator: Coordinator)
}

protocol Coordinator: AnyObject, CoordinatorDelegate{
    var delegate: CoordinatorDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


extension Coordinator {
    func start() { }
    
    func coordinatorDidFinish() {
        delegate?.removeChildCoordinator(self)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        for (index, child) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}


protocol CoordinatorContext {
    associatedtype T: Coordinator
    var coordinator: T? { get set }
}
