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

class RegisterIconViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    var assets: PHFetchResult<PHAsset>!
    
    var allow: Bool = false
    
    struct Input {
        let tapUploadButton = PublishSubject<Void>()
    }
    
    struct Output {
        let photo = PublishRelay<UIImage?>()
    }
    
    init(isPrivate: Bool) {
        super.init()
    }
    
    override func bind() {
    }
    
    func requestPhotosPermission() {
        let photoAuthorizationStatusStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatusStatus {
        case .authorized:
            self.allow = true
//            self.requestPhotos()
        case .denied:
            print("Photo Authorization status is denied.")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    print("authorized.")
//                    self.requestPhotos()
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
