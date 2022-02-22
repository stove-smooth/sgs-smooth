//
//  EditProfileViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: BaseViewController {
    
    weak var coordinator: ProfileCoordinator?
    
    private var editView = EditProfileView()
    private let viewModel: EditProfileViewModel
    
    let user: User
    
    init(user: User) {
        self.user = user
        self.viewModel = EditProfileViewModel(
            user: user, userService: UserService(), userDefaults: UserDefaultsUtil()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(user: User) -> EditProfileViewController {
        return EditProfileViewController(user: user)
    }
    
    private func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        super.view = self.editView
        editView.bind(user: self.user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        title = "사용자 프로필"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.editView.imgUploadButton.rx.tap
            .flatMap { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) {
                    picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }.take(1)
            }.map { info in
                return info[.editedImage] as? UIImage
            }.subscribe(onNext: { image in
                self.editView.upload(image: image)
                self.viewModel.output.image.accept(image)
            }).disposed(by: disposeBag)
        
        self.editView.bioLabelField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.bioTextField)
            .disposed(by: disposeBag)
        
        self.viewModel.output.showSaveButton
            .asDriver()
            .drive(onNext: {value in
                self.editView.saveButton.isHidden = !value
            }).disposed(by: disposeBag)
        
        self.editView.saveButton.rx.tap
            .bind(to: self.viewModel.input.tapSaveButton)
            .disposed(by: disposeBag)

        // MARK: toast message
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
    }
}

