//
//  RegisterViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

class RegisterServerViewController: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let registerView = RegisterServerView()
    
    private let viewModel: RegisterServerViewModel
    private let userDefault: UserDefaultsUtil
    
    
    init(isPrivate: Bool) {
        self.viewModel = RegisterServerViewModel(
            isPrivate: isPrivate,
            serverRepository: ServerRepository()
        )
        self.userDefault = UserDefaultsUtil()
        
        print("isPrivate \(isPrivate)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(isPrivate: Bool) -> RegisterServerViewController {
        return RegisterServerViewController(isPrivate: isPrivate)
    }
    
    override func loadView() {
        let user = self.userDefault.getUserInfo()
        guard let user = user else {
            return
        }
        
        view = registerView
        registerView.set(name: user.name)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coordinator?.modalNav.isNavigationBarHidden = false
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
                self.viewModel.output.icon.accept(image!)
            })
            .disposed(by: disposeBag)
        
        self.registerView.serverNameLabelField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.serverNameLabelField)
            .disposed(by: disposeBag)
        
        self.registerView.registerButton.rx.tap
            .bind(to: self.viewModel.input.tapRegisterButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToInvitation
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToInvitation)
            .disposed(by: disposeBag)
    }
    
    func goToInvitation() {
        print("코디네이터 움직이기")
    }
}
