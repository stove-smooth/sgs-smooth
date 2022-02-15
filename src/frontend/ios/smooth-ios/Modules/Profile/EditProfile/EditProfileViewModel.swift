//
//  EditProfileViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import RxSwift
import RxCocoa

class EditProfileViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model: Model
    
    let userService: UserServiceProtocol
    let userDefaults: UserDefaultsUtil
    
    var image: UIImage?
    
    struct Input {
        let bioTextField = BehaviorRelay<String>(value: "")
        let uploadedImage = PublishSubject<UIImage?>()
        
        let tapSaveButton = PublishSubject<Void>()
    }
    
    struct Output {
        let image = PublishRelay<UIImage?>()
        let showSaveButton = BehaviorRelay<Bool>(value: true)
    }
    
    struct Model {
        var user: User
    }
    
    init(
        user: User,
        userService: UserServiceProtocol,
        userDefaults: UserDefaultsUtil
    ) {
        self.model = Model(user: user)
        self.userService = userService
        self.userDefaults = userDefaults
        super.init()
    }
    
    override func bind() {
        self.output.image
            .subscribe(onNext: { image in
                self.image = image
                self.showSaveButton()
            }).disposed(by: disposeBag)
        
        self.input.bioTextField
            .subscribe(onNext: { value in
                self.showSaveButton()
            }).disposed(by: disposeBag)
        
        self.input.tapSaveButton
            .bind(onNext: { [self] in
                showLoading.accept(true)
                
                let newBio = self.input.bioTextField.value
                if newBio != self.model.user.bio {
                    self.updateUserBio(bio: newBio)
                }
                
                if self.image != nil {
                    self.updateUserProfile()
                }
                showLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
        self.showLoading.bind(onNext: { value in
            if (value == false) {
                self.showToastMessage.accept("변경 완료")
            }
        }).disposed(by: disposeBag)
    }
    
    private func showSaveButton() {
        let show = (self.image != nil) || (self.model.user.bio != self.input.bioTextField.value)
        self.output.showSaveButton.accept(show)
    }
    
    private func updateUserBio(bio: String) {
        userService.updateUserBio(bio) {
         response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                let newUser = User(id: self.model.user.id,
                                   email: self.model.user.email,
                                   name: self.model.user.name,
                                   code: self.model.user.code,
                                   profileImage: self.model.user.profileImage,
                                   bio: bio)
                self.model.user = newUser
                self.userDefaults.setUserInfo(user: newUser)
            }
        }
    }

    private func updateUserProfile() {
        let img = self.image?.resizeImage(size: CGSize(width: 200, height: 200))
        userService.updateUserProfile(img?.jpegData(compressionQuality: 0.7)) {
         response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.fetchUserInfo()
            }
        }
    }
    
    private func fetchUserInfo() {
        self.userService.fetchUserInfo { user, error in
            
            guard let user = user else {
                return
            }
            
            self.userDefaults.setUserInfo(user: user)
        }
    }
}
