//
//  BaseViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import RxSwift
import RxCocoa

class BaseViewModel {
    let disposeBag = DisposeBag()
    let showLoading = PublishRelay<Bool>()
    let showErrorMessage = PublishRelay<String>()
    let showToastMessage = PublishRelay<String>()
    
    init() {
        self.bind()
    }
    
    func bind() {
        // input이랑 output 연결
    }
}

