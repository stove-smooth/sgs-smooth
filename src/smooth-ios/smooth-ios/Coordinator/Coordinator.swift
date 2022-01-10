//
//  Coordinator.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
