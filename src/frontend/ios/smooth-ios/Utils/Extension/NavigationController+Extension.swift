//
//  NavigationController+Extension.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/11.
//

import UIKit

extension UINavigationController {
    var setup: UINavigationController{
        let navigationController = UINavigationController()

        navigationController.navigationBar.shadowImage = nil
        navigationController.navigationBar.setBackgroundImage(nil, for: .compact)

        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barTintColor = UIColor.backgroundDarkGray
        navigationController.navigationBar.backgroundColor = .backgroundDarkGray

        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white!]

        return navigationController
    }
}
