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

class ContainerViewController: BaseViewController {
    
    weak var delegate: ContainerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton)
        )
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
}
