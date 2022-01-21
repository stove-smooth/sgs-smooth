//
//  FriendRequestViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import UIKit
import Then
import RxSwift
import RxCocoa

protocol FriendRequestDelegate: class {
    func onClose()
}

class FriendRequestViewController: BaseViewController {
    var navigationViewController: UINavigationController?
    weak var delegate: FriendRequestDelegate?
    
    private let requestView = FriendRequestView()
    private let viewModel = FriendRequestViewModel()
    
    static func instance() -> UINavigationController {
        let friendVC = FriendRequestViewController(nibName: nil, bundle: nil)
        
        return UINavigationController(rootViewController: friendVC).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.isNavigationBarHidden = true
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onClose()
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
        
        self.requestView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
    }
}

