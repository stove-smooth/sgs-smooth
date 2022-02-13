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
import MessageKit

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
        
        let socketMessage = PublishSubject<MockMessage?>()
    }
    
    struct Output {
        let channel = PublishRelay<Channel>()
        let commniutyId = PublishRelay<Int?>()
        let messages = PublishRelay<[MockMessage]>()
        
        let showEmpty = PublishRelay<Bool>()
        let isLoading = PublishRelay<Bool>()
    }
    
    struct Model {
        var messages = [MockMessage]()
    }
    
    init(
        chattingService: ChattingServiceProtocol
    ) {
        self.chattingService = chattingService
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.chatWebSocketService = appDelegate?.chatWebSocketService as! ChatWebSocketService
        
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: { channel in
                self.connect(channelId: channel.id)
                self.fetchMessgae(chattingId: channel.id)
            })
            .disposed(by: disposeBag)
        
        chatWebSocketService.message
            .subscribe(onNext: { message in
                self.model.messages.append(message)
                self.output.messages.accept(self.model.messages)
                
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
                
                var fetchmessages: [MockMessage] = []
                
                for msg in response {
                    var newMessage: MockMessage?
                    
                    switch msg.fileType {
                    case .image:
                        newMessage = MockMessage(image: msg.message.toUIImage()!,
                                                 user: MockUser(senderId: "\(msg.userId)", displayName: msg.name,
                                                profileImage: msg.profileImage),
                                                 messageId: msg.id,
                                                 date: msg.time.ISOtoDate
                        )
                    case .file: break
                    case .video: break
                    case .reply: // TODO: 이미지 답글인 경우 확인 필요
                        newMessage = MockMessage(
                            kind: MessageKind.text(msg.message),
                            user: MockUser(senderId: "\(msg.userId)",
                                           displayName: msg.name,
                                           profileImage: msg.profileImage),
                            messageId: msg.id,
                            date: msg.time.ISOtoDate
                        )
                    case .none:
                        newMessage = MockMessage(
                            kind: MessageKind.text(msg.message),
                            user: MockUser(senderId: "\(msg.userId)",
                                           displayName: msg.name,
                                           profileImage: msg.profileImage),
                            messageId: msg.id,
                            date: msg.time.ISOtoDate
                        )
                    }
                    
                    fetchmessages.append(newMessage!)
                }
                
                self.output.showEmpty.accept(response.count == 0)
                self.model.messages = fetchmessages
                self.output.messages.accept(fetchmessages)
            }
        }
    }
    
    private func connect(channelId: Int) {
        self.chatWebSocketService.connect(channelId: channelId)
    }
    
    func sendMessage(message: String, communityId: Int?) {
        self.output.isLoading.accept(true)
        self.chatWebSocketService.sendMessage(message: message, communityId: communityId)
        self.output.isLoading.accept(false)
    }
    
    func sendFileMessage(request: FileMessageRequest) {
        self.output.isLoading.accept(true)
        self.chattingService.sendFileMessage(request) {
            response, error in
            guard let response = response else {
                return
            }
            
            if (!response.isSuccess) {
                self.showErrorMessage.accept("메시지 보내는데 실패하였습니다.")
            }
            
            self.output.isLoading.accept(false)
        }
    }
    
    func deleteMessage(message: MockMessage) {
        self.chatWebSocketService.deleteMessage(message: message)
    }
}
