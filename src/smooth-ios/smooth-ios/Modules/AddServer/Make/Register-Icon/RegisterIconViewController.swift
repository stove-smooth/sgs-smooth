//
//  RegisterIconViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class RegisterIconViewController: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let registerView = RegisterIconView()
    
    private let viewModel: RegisterIconViewModel
    private let userDefault: UserDefaultsUtil
    
    
    init(isPrivate: Bool) {
        self.viewModel = RegisterIconViewModel(isPrivate: isPrivate)
        
        self.userDefault = UserDefaultsUtil()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(isPrivate: Bool) -> RegisterIconViewController {
        return RegisterIconViewController(isPrivate: isPrivate)
    }
    
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.requestPhotosPermission()
    }
    
    override func bindViewModel() {
        self.registerView.uploadButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[.editedImage] as? UIImage
            }.subscribe(onNext: { image in
                self.registerView.bind(image: image)
            })
            .disposed(by: disposeBag)
    }
    
    
}
