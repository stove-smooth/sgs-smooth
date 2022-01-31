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
    
    private let makeView = MakeServerView()
    private let viewModel: MakeServerViewModel
    
    let categoryId: Int
    
    init(categoryId: Int) {
        self.categoryId = categoryId
        self.viewModel = MakeServerViewModel(channelRepository: ChannelRepository())
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
        self.coordinator?.goToMenu()
    }
    
    override func loadView() {
        super.view = self.makeView
    }
    
    override func viewDidLoad() {
        
    }
    
    override func bindViewModel() {
//        self.makeView.closeButton.rx.tap
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: self.dismiss)
//            .disposed(by: disposeBag)
    }
}
