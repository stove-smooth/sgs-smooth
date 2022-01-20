//
//  FriendEmptyViewController.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class FriendEmptyViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: FriendCoordinator?
    var navigationViewController: UINavigationController?
    
    private let emptyView = FriendEmptyView()
    private let viewModel = FriendEmptyViewModel()
    
    static func instance() -> FriendEmptyViewController {
        return FriendEmptyViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.emptyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "친구"
    }
    
    override func bindViewModel() {
        self.emptyView.friendButton.rx.tap
            .bind(to: self.viewModel.input.tapRequestButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToRequest
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToRequeset)
            .disposed(by: disposeBag)
    }
    
                  
    func goToRequeset() {
        self.coordinator?.goToRequest()
    }
}
