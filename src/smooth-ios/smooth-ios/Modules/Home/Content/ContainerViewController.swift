//
//  ContainerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit

protocol ContainerViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ContainerViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ContainerViewControllerDelegate?
    
    static func instance() -> ContainerViewController {
        return ContainerViewController(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Container ViewController"
        self.tabBarController?.tabBar.isHidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton)
        )
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
}
