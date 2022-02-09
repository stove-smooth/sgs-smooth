//
//  EditProfileViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class EditServerInfoViewController: BaseViewController {
    
    weak var coordinator: ServerSettingCoordinator?
    
    private var editView = EditServerInfoView()
    private let viewModel: EditServerInfoViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = EditServerInfoViewModel(server: server, ServerService: ServerService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> EditServerInfoViewController {
        return EditServerInfoViewController(server: server)
    }
    
    private func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func loadView() {
        super.view = self.editView
        editView.bind(server: self.server)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "일반"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
        
        self.editView.serverNameLabelField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.serverTextField)
            .disposed(by: disposeBag)
        
        self.viewModel.output.showSaveButton
            .asDriver()
            .drive(onNext: {value in
                self.editView.saveButton.isHidden = !value
            }).disposed(by: disposeBag)
        
        self.editView.saveButton.rx.tap
            .bind(to: self.viewModel.input.tapSaveButton)
            .disposed(by: disposeBag)
        
        self.editView.deleteButton.rx.tap
            .bind(onNext: self.showDeleteServer)
            .disposed(by: disposeBag)
        
        self.viewModel.output.deleteServer
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.dismiss()
                self.coordinator?.goToMain()
            }).disposed(by: disposeBag)
        
        // MARK: toast message
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func showDeleteServer() {
        AlertUtils.showWithCancel(
            controller: self,
            title: "서버 삭제",
            message: "정말 \(self.server.name) 채널을 삭제하시겠어요? 삭제된 채널은 복구할 수 없어요."
        ) {
            self.viewModel.input.tapDeleteServer.onNext(())
        }
    }
}
