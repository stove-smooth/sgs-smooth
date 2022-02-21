//
//  HomeViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import RxSwift

enum DestinationStatus {
    case home
    case direct(Int) // direct room id
    case community((Int, Int, Bool)) // community, channel id,
}

enum MenuState {
    case opened
    case closed
}

class HomeViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let chatWebSocketService: ChatWebSocketServiceProtocol
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let moving = PublishSubject<DestinationStatus>()
    }
    
    struct Output {
        let menuState = PublishSubject<MenuState>()
    }
    
    struct Model {
        var menuState: MenuState = .opened
        var isStart = true
    }
    
    init(
        chatWebSocketService: ChatWebSocketServiceProtocol
    ) {
        self.chatWebSocketService = chatWebSocketService
        
        super.init()
    }
    
    override func bind() {
        self.input.viewDidLoad
            .bind(onNext: {
                if (self.model.isStart) {
                    self.output.menuState.onNext(self.model.menuState)
                    self.model.isStart = false 
                }
            }).disposed(by: disposeBag)
        
        self.input.moving
            .bind(onNext: { destination in
                self.chatWebSocketService.joinChannel(destination)
            })
            .disposed(by: disposeBag)
        
    }
}
