//
//  RegisterIconViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import RxSwift
import RxCocoa
import Photos
import UIKit

class RegisterServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    var isPrivate: Bool
    var icon: UIImage?
    let serverService: ServerServiceProtocol
    
    struct Input {
        let tapUploadButton = PublishSubject<Void>()
        let serverNameLabelField = BehaviorRelay<String>(value: "")
        let tapRegisterButton = PublishSubject<Void>()
    }
    
    struct Output {
        let icon = PublishRelay<UIImage>()
        let goToInvitation = PublishRelay<Int>()
    }
    
    init(isPrivate: Bool,             serverService: ServerServiceProtocol) {
        self.isPrivate = isPrivate
        self.serverService =             serverService
    }
    
    override func bind() {
        self.input.tapRegisterButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.createServer(
                    request: ServerRequest(
                        name: self.input.serverNameLabelField.value,
                        public: !self.isPrivate,
                        icon: self.icon?.jpegData(compressionQuality: 0.7)
                    ))
            })
            .disposed(by: disposeBag)
        
        self.output.icon
            .subscribe(onNext: { image in
                self.icon = image
            })
            .disposed(by: disposeBag)
    }
    
    func createServer(request: ServerRequest) {
        serverService.createServer(request) { server, error in
            guard let server = server else {
                return
            }
            
            self.output.goToInvitation.accept(server.id)
            if (error != nil) {
                print("network error 처리")
            }
        }
    }
    
    func requestPhotosPermission() {
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
        case .authorized:
            break
        case .denied:
            print("Photo Authorization status is denied.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    print("authorized.")
                case .denied:
                    print("User denied.")
                    // TODO: 다시 요청 보내기
                default:
                    break
                }
            }
        case .restricted:
            print("Photo Authorization status is restricted.")
        default:
            break
        }
    }
}
