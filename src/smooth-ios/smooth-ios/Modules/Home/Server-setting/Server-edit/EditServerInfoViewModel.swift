//
//  EditProfileViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import RxSwift
import RxCocoa

class EditServerInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverService: ServerServiceProtocol
    let server: Server
    
    var image: UIImage?
    
    struct Input {
        let tapDeleteServer = PublishSubject<Void>()
        let serverTextField = BehaviorRelay<String>(value: "")
        let uploadedImage = PublishSubject<UIImage?>()
        
        let tapSaveButton = PublishSubject<Void>()
    }
    
    struct Output {
        let deleteServer = PublishRelay<Void>()
        let image = PublishRelay<UIImage?>()
        let showSaveButton = BehaviorRelay<Bool>(value: true)
    }
    
    init(
        server: Server,
        ServerService: ServerServiceProtocol
    ) {
        self.server = server
        self.serverService = ServerService
        super.init()
    }
    
    override func bind() {
        self.input.tapDeleteServer
            .bind(onNext: {
                self.deleteServer(serverId: self.server.id)
            }).disposed(by: disposeBag)
        
        self.output.image
            .subscribe(onNext: { image in
                self.image = image
                self.showSaveButton()
            }).disposed(by: disposeBag)
        
        self.input.serverTextField
            .subscribe(onNext: { value in
                self.showSaveButton()
            }).disposed(by: disposeBag)
        
        self.input.tapSaveButton
            .bind(onNext: { [self] in
                showLoading.accept(true)
                
                if self.image != nil {
                    self.updateServerIcon()
                }
                
                let newName = self.input.serverTextField.value
                if newName != self.server.name {
                    self.updateServerName(name: newName)
                }
                showLoading.accept(false)
                showToastMessage.accept("변경 완료")
            })
            .disposed(by: disposeBag)
    }
    
    private func showSaveButton() {
        let show = (self.image != nil) || (self.input.serverTextField.value != server.name)
        self.output.showSaveButton.accept(show)
    }
    
    private func deleteServer(serverId: Int) {
        serverService.deleteServer(serverId) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.output.deleteServer.accept(())
            }
        }
    }
    
    private func updateServerName(name: String) {
        serverService.updateServerName(serverId: server.id, name: name) {
         response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
        }
    }

    private func updateServerIcon() {
        let img = self.image?.resizeImage(size: CGSize(width: 200, height: 200))
        serverService.updateServerIcon(serverId: server.id, imageData: img?.jpegData(compressionQuality: 0.7)) {
         response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
        }
    }
}
