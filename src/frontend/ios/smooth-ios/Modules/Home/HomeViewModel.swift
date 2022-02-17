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
    case community((Int, Int)) // community, channel id
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
        let moving = PublishSubject<DestinationStatus>()
    }
    
    struct Output {
        let menuState = PublishSubject<MenuState>()
    }
    
    struct Model {
        var menuState: MenuState = .closed
    }
    
    init(
        chatWebSocketService: ChatWebSocketServiceProtocol
    ) {
        self.chatWebSocketService = chatWebSocketService
        
        super.init()
    }
    
    override func bind() {
        self.input.moving
            .bind(onNext: { destination in
                self.chatWebSocketService.joinChannel(destination)
            })
            .disposed(by: disposeBag)
        
    }
}
