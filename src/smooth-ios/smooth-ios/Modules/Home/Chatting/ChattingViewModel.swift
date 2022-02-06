//
//  ChattingViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa
import StompClientLib

class ChattingViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let chattingService: ChattingServiceProtocol
    let chatWebSocketService: ChatWebSocketService
    
    struct Input {
        let fetch = PublishSubject<Channel>()
        let page = BehaviorRelay<Int>(value: 0)
        let size = BehaviorRelay<Int>(value: 20)
    }
    
    struct Output {
        let channel = PublishRelay<Channel>()
        let messages = PublishRelay<[Message]>()
        
        let showEmpty = PublishRelay<Bool>()
    }
    
    struct Model {
        var messgae: [Message] = []
    }
    
    init(
        chattingService: ChattingServiceProtocol,
        chatWebSocketService: ChatWebSocketService
    ) {
        self.chattingService = chattingService
        self.chatWebSocketService = chatWebSocketService
        
        super.init()
        chatWebSocketService.delegate = self
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: { channel in
                self.connect(channelId: channel.id)
                self.fetchMessgae(chattingId: channel.id)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMessgae(chattingId: Int) {
        let page = self.input.page.value
        let size = self.input.size.value
        
        chattingService.fetchMessgae(chattingId, page: page, size: size) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let response = response else {
                    return
                }
                
                self.output.showEmpty.accept(response.count == 0)
                self.model.messgae = response
                self.output.messages.accept(response)
            }
        }
    }
    
    private func connect(channelId: Int) {
        chatWebSocketService.register(channelId: channelId)
    }
    
    func sendMessage(message: String) {
        chatWebSocketService.sendMessage(message: message)
    }
}

extension ChattingViewModel: StompClientLibDelegate {
    // MARK: - StompClient Delegate
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
      print("DESTINATION : \(destination)")
      print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        chatWebSocketService.connection = false
        chatWebSocketService.disconnect()
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        chatWebSocketService.connection = true
        chatWebSocketService.connect()
        print("Socket is Connected \(chatWebSocketService.channelId)")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Failed to Connect!-- Error : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
}
