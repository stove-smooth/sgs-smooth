//
//  FriendRequestViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class FriendRequestViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: FriendCoordinator?
    var navigationViewController: UINavigationController?
    
    private let requestView = FriendRequestView()
    private let viewModel = FriendRequestViewModel()
    
    static func instance() -> FriendRequestViewController {
        return FriendRequestViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.requestView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setNavigation()
    }
    
    func setNavigation() {
        let buttonImg = UIImage(named: "User+Add")?.resizeImage(size: CGSize(width: 25, height: 25))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: buttonImg,
            style: .plain,
            target: self,
            action: nil //didTapAddButton
        )
    
        self.title = "친구 추가하기"
    }
    
    override func bindViewModel() {
        self.requestView.requestButton.rx.tap
            .bind(to: self.viewModel.input.tapRequestButton)
            .disposed(by: disposeBag)
        
        self.requestView.userField.rx.text
            .orEmpty
            .bind(to: viewModel.input.userTextField)
            .disposed(by: disposeBag)
    }
}

