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
    
    weak var coordinator: HomeCoordinator?
    
    private let editView = EditServerInfoView()
    private let viewModel: EditServerInfoViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = EditServerInfoViewModel(server: server, serverRepository: ServerRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> UINavigationController {
        let editVC = EditServerInfoViewController(server: server)
        
        return UINavigationController(rootViewController: editVC).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.isNavigationBarHidden = true
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.view = self.editView
        editView.bind(server: self.server)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.editView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
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
            }).disposed(by: disposeBag)
        
        
        self.editView.deleteButton.rx.tap
            .bind(onNext: self.showDeleteServer)
            .disposed(by: disposeBag)
        
        self.viewModel.output.deleteServer
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.dismiss()
                self.coordinator?.goToMenu()
            }).disposed(by: disposeBag)
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
