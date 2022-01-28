//
//  JoinServerViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/27.
//

import RxSwift
import RxCocoa
import Moya

class JoinServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverRepository: ServerRepositoryProtocol
    var code: String?
    
    init(
        serverRepository: ServerRepositoryProtocol
    ) {
        self.serverRepository = serverRepository
    }
    
    struct Input {
        let tapJoinButton = PublishSubject<Void>()
        let inputServerCode = PublishSubject<String>()
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
    }
    
    override func bind() {
        self.input.inputServerCode
            .subscribe(onNext: {
                self.code = $0
            })
            .disposed(by: disposeBag)
        
        self.input.tapJoinButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.joinServer(serverCode: self.code!)
            })
            .disposed(by: disposeBag)
    }
    
    private func joinServer(serverCode: String) {
        serverRepository.joinServer(serverCode){ server, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.showToastMessage.accept("요청에 성공하였습니다.")
            }
        }
    }
}
