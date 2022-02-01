//
//  MakeCategoryViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import PanModal
import RxSwift
import RxCocoa

class MakeCategoryViewController: BaseViewController {
    var panScrollable: UIScrollView?
    
    weak var coordinator: HomeCoordinator?
    
    private let makeView = MakeCategoryView()
    private let viewModel: MakeCategoryViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = MakeCategoryViewModel(server: server, categoryRepository: CategoryRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> MakeCategoryViewController {
        return MakeCategoryViewController(server: server).then {
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
        
        self.makeView.categoryNameInput.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.categoryNameInput)
            .disposed(by: disposeBag)
        
        self.makeView.accessButton.rx.isOn
            .bind(to: self.viewModel.input.isPublic)
            .disposed(by: disposeBag)
        
        self.makeView.makeButton.rx.tap
            .bind(to: self.viewModel.input.tapMakeButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToMain
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
    }
}
