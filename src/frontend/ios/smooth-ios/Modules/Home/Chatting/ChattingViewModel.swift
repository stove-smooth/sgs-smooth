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
    var model: Model
    
    let chattingService: ChattingServiceProtocol
    let chatWebSocketService: ChatWebSocketServiceProtocol
    
    struct Input {
        let fetch = PublishSubject<(Int?, Int?)>()
        
        let socketMessage = PublishSubject<(MockMessage, ReceivedMessageType)>()
        
        let inputMessage = PublishSubject<String?>()
        let disappear = PublishSubject<Void>()
    }
    
    struct Output {
        let channel = PublishRelay<(Int, String)>()
        
        let messages = PublishRelay<([MockMessage],ReceivedMessageType?)>()
        let socketMessage = PublishSubject<MockMessage>()
        
        let showEmpty = PublishRelay<Bool>()
        let isLoading = PublishRelay<Bool>()
        let typing = PublishSubject<String>()
    }
    
    struct Model {
        let messageUser: MockUser
        var messages = [MockMessage]()
        var members: [Member]?
        
        var communityId: Int?
        var channel: (Int, String) = (0, "채팅 없음") // 채널id, 채널 이름 
        
        var isConnected = false
        var edittingMsg: MockMessage?
        // 페이징 처리 기본 값
        var page: Int = 0
        let size: Int = 20 // (고정)
    }
    
    init(
        messageUser: MockUser,
        chattingService: ChattingServiceProtocol,
        chatWebSocketService: ChatWebSocketServiceProtocol
    ) {
        self.model = Model(messageUser: messageUser)
        self.chattingService = chattingService
        self.chatWebSocketService = chatWebSocketService
        
        super.init()
    }
    
    // MARK: model message에서 찾고자 하는 메시지의 index 찾기
    func searchIndex(message: MockMessage) -> Int {
        let message = self.model.messages
            .filter { $0.messageId == message.messageId}
            .compactMap { $0 }
            .first
        let index = self.model.messages.firstIndex(of: message!)
        
        return index!
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: { channelId, page in
                guard let channelId = channelId else { return }
                self.connect(channelId: channelId)
                if (self.model.communityId == nil) {
                    self.fetchMessgaeByDirect(chattingId: channelId)
                } else {
                    self.fetchMessgaeByCommunity(chattingId: channelId)
                    self.chatWebSocketService.communitySignaling(communityId: self.model.communityId!)
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - socket으로 온 메시지 처리
        chatWebSocketService.message
            .bind { (message, type) in
                switch type {
                case .message: // 메시지 보내기
                    self.model.messages.append(message)
                    self.output.messages.accept(( self.model.messages, .message))
                case .delete: // 메시지 삭제
                    let index = self.searchIndex(message: message)
                    
                    self.model.messages.remove(at: index)
                    self.output.messages.accept((self.model.messages, .delete))
                case .modify: // 메시지 수정
                    let index = self.searchIndex(message: message)
                    self.model.messages[index].sentDate = message.sentDate
                    self.model.messages[index].kind = message.kind
                    self.output.messages.accept(( self.model.messages, .modify))
                    self.showToastMessage.accept("메시지 수정 완료")
                case .reply: // 메시지 답장
                    break
                case .typing: // 메시지 입력중
                    switch message.kind {
                    case .text(let text):
                        self.output.typing.onNext(text)
                    default: break
                    }
                }
            }.disposed(by: disposeBag)
        
        // MARK: - socket으로 메시지 보내기
        self.input.socketMessage
            .bind { (message, type) in
                switch type {
                case .message:
                    switch (message.kind) {
                    case .text(let text):
                        self.sendMessage(message: text)
                    case .photo(let img):
                        let thumb = img.image!.generateThumbnail()!
                        
                        let request = FileMessageRequest(
                            image: img.image!.jpegData(compressionQuality: 0.5),
                            thumbnail: thumb.data,
                            userId: Int(self.model.messageUser.senderId)!,
                            channelId: self.model.channel.0,
                            communityId: self.model.communityId,
                            type: self.model.communityId != nil ? "community" : "direct",
                            fileType: FileType.image,
                            name: self.model.messageUser.displayName,
                            profileImage: self.model.messageUser.profileImage
                        )
                        self.sendFileMessage(request: request)
                    default: break
                    }
                case .delete:
                    self.deleteMessage(message: message)
                case .modify:
                    self.modifyMessage(message: message)
                case .reply: break
                case .typing: break
                }
                
            }.disposed(by: disposeBag)
        
        self.input.inputMessage
            .subscribe(onNext: { value in
                self.chatWebSocketService.typing()
            })
            .disposed(by: disposeBag)
        
        self.input.disappear
            .bind(onNext: {
                self.chatWebSocketService.disconnect()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: 메시지 불러오기
    private func fetchMessgaeByCommunity(chattingId: Int) {
        let page = self.model.page
        let size = self.model.size
        
        chattingService.fetchMessgaeByCommunity(chattingId, page: page, size: size) { response, error in
            if (error?.response != nil) {
                // MARK: messageKit DTO
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let response = response else {
                    return
                }
                
                let isLast = self.fetchMessageToModel(response: response)
                
                if (!isLast) {
                    self.model.page = page + 1
                }
               
            }
        }
    }
    
    private func fetchMessgaeByDirect(chattingId: Int) {
        let page = self.model.page
        let size = self.model.size
        
        chattingService.fetchMessgaeByDirect(chattingId, page: page, size: size) { response, error in
            if (error?.response != nil) {
                // MARK: messageKit DTO
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let response = response else {
                    return
                }
                
                self.fetchMessageToModel(response: response)
                self.model.page = page + 1
            }
        }
    }
    
    private func fetchMessageToModel(response: [Message]) -> Bool {
        var fetchMessages: [MockMessage] = []
        
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
                // TODO: 답글인 경우 acessory 표시
                newMessage = MockMessage(
                    kind: MessageKind.text(msg.message),
                    user: MockUser(senderId: "\(msg.userId)",
                                   displayName: msg.name,
                                   profileImage: msg.profileImage),
                    messageId: msg.id,
                    date: msg.time.ISOtoDate
                )
            }
            
            fetchMessages.append(newMessage!)
        }
        // self.output.showEmpty.accept(response.count == 0)
        
        if (self.model.messages.isEmpty && !fetchMessages.isEmpty) {
            self.model.messages = fetchMessages
        } else {
            self.model.messages.insert(contentsOf: fetchMessages, at: 0)
        }
        
        self.output.messages.accept((fetchMessages, .none))
        
        return fetchMessages.isEmpty
    }
    
    // MARK: - chatWebsocket
    private func connect(channelId: Int) {
        
        if (!self.chatWebSocketService.isConnected) {
            self.chatWebSocketService.connect(channelId: channelId, isGroup: self.model.communityId != nil)
        }
        
        self.model.isConnected = true
    }
    
    private func disappear() {
        self.chatWebSocketService.disconnect()
        self.model.isConnected = false
    }
    
    private func sendMessage(message: String) {
        self.output.isLoading.accept(true)
        self.chatWebSocketService.sendMessage(message: message, communityId: self.model.communityId)
        self.output.isLoading.accept(false)
    }
    
    private func sendFileMessage(request: FileMessageRequest) {
        self.output.isLoading.accept(true)
        self.chattingService.sendFileMessage(request) {
            response, error in
            guard let response = response else {
                return
            }
            
            if (!response.isSuccess) {
                self.showErrorMessage.accept("메시지 전송 실패")
            }
            
            self.output.isLoading.accept(false)
        }
    }
    
    private func deleteMessage(message: MockMessage) {
        self.chatWebSocketService.deleteMessage(message: message)
        
        let index = self.model.messages.firstIndex(of: message)
        //        self.model.messages.remove(at: index!)
        //        self.output.messages.accept(self.model.messages)
        self.showToastMessage.accept("메시지 삭제 완료")
    }
    
    private func modifyMessage(message: MockMessage) {
        self.chatWebSocketService.modifyMessage(message: message)
        
        //        var index: Int?
        //
        //        for i in 0...self.model.messages.count-1 {
        //            if(self.model.messages[i].messageId == message.messageId) {
        //                index = i
        //
        //            }
        //        }
        ////        self.model.messages[index!] = message
        ////        self.output.messages.accept(self.model.messages)
    }
    
    private func typing() {
        self.chatWebSocketService.typing()
    }
}
