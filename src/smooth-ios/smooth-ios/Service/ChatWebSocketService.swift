//
//  ChatWebSocketService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import Foundation
import StompClientLib
import MessageKit
import RxSwift

protocol ChatWebSocketServiceProtocol {
    func setup()
    func register()
    func connect(channelId: Int)
    func disconnect()
    func sendMessage(message: String, communityId: Int?)
}

class ChatWebSocketService: NSObject, ChatWebSocketServiceProtocol {
    let socketClient = StompClientLib()
    
    let baseURL = "http://3.36.238.237:8080"
    var url = NSURL()
    var channelId: Int?
    var user: User?
    
    var header: [String: String] = [:]
    var message = PublishSubject<MockMessage>()
    
    private var reconnectTimer : Timer?
    
    func setup() {
        let userDefaults = UserDefaultsUtil()
        guard let user = userDefaults.getUserInfo() else { return }
        self.user = user
        
        self.header = [
            "access-token": userDefaults.getUserToken(),
            "user-id": "\(user.id)",
        ]
    }
    
    func register() {
        self.setup()
        
        let wsURL = baseURL[baseURL.index(baseURL.startIndex, offsetBy: 7)...]
        let completedWSURL = "ws://\(wsURL)/my-chat/websocket"
        
        url = NSURL(string: completedWSURL)!
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: self.header)
    }
    
    func connect(channelId: Int) {
        self.channelId = channelId
        let destination = "/topic/group/\(channelId)"
        
        socketClient.subscribe(destination: destination)
        print("socket subscribe - \(destination)")
    }
    
    func disconnect() {
        guard let channelId = self.channelId else {
            return
        }
        socketClient.unsubscribe(destination: "/topic/group/\(channelId)")
    }
    
    func autoReconnect(){
        socketClient.autoDisconnect(time: 3)
        socketClient.reconnect(request: NSURLRequest(url: url as URL), delegate: self, time: 4.0)
    }
    
    func sendMessage(message: String, communityId: Int?) {
        guard let user = user else {
            return
        }

        var payloadObject = [
            "content": message,
            "channelId": "\(channelId!)",
            "userId": "\(user.id)",
            "name": "\(user.name)",
            "profileImage": user.profileImage as Any
        ] as [String : Any]
        
        if communityId != nil {
            payloadObject["communityId"] = communityId
        }
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-channel-message")
    }
}


// MARK: - StompClient Delegate
extension ChatWebSocketService: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
        
        guard let stringBody = stringBody else {
            return
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let messagePayload = try! decoder.decode(MessagePayload.self, from: stringBody.data(using: .utf8)!)
        
        let newMessage = MockMessage(text: messagePayload.message, user: MockUser(senderId: messagePayload.userId, displayName: messagePayload.name), messageId: UUID().uuidString, date: Date())
        
        self.message.onNext(newMessage)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        self.disconnect()
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is Connected")
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
