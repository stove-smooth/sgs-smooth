//
//  MakeChannelViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import PanModal
import RxSwift
import RxCocoa

class MakeChannelViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    weak var coordinator: HomeCoordinator?
    
    private let makeView = MakeChannelView()
    private let viewModel: MakeChannelViewModel
    
    let categoryId: Int
    
    init(categoryId: Int) {
        self.categoryId = categoryId
        self.viewModel = MakeChannelViewModel(categoryId: categoryId, channelService: ChannelService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(categoryId: Int) -> MakeChannelViewController {
        return MakeChannelViewController(categoryId: categoryId).then {
            $0.modalPresentationStyle = .fullScreen
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
//        self.coordinator?.goToMenu()
    }
    
    override func loadView() {
        super.view = self.makeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.makeView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.makeView.channelNameInput.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.channelNameInput)
            .disposed(by: disposeBag)
        
        self.makeView.chattingButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.makeView.setType(chat: true)
                self.viewModel.input.isChat.accept(true)
            })
            .disposed(by: disposeBag)
        
        self.makeView.voiceButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.makeView.setType(chat: false)
                self.viewModel.input.isChat.accept(false)
            })
            .disposed(by: disposeBag)
        
        self.makeView.accessButton.rx.isOn
            .bind(to: self.viewModel.input.isPublic)
            .disposed(by: disposeBag)
        
        self.makeView.makeButton.rx.tap
            .bind(to: self.viewModel.input.tapMakeButton)
            .disposed(by: disposeBag)
        
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
    }
}
