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
import UIKit

enum ReceivedMessageType: String, Codable {
    case message = "message"
    case modify = "modify"
    case delete = "delete"
    case reply = "reply"
    case typing = "typing"
}

protocol ChatWebSocketServiceProtocol {
    var message: PublishSubject<(MockMessage, ReceivedMessageType)> { get set }
    var isConnected: Bool { get set }
    
    func setup()
    func register()
    func connect(channelId: Int, isGroup: Bool)
    func disconnect()
    
    func sendMessage(message: String, communityId: Int?)
    func deleteMessage(message: MockMessage)
    func modifyMessage(message: MockMessage)
    func typing()
    func communitySignaling(communityId: Int)
}

class ChatWebSocketService: NSObject, ChatWebSocketServiceProtocol {
    let socketClient = StompClientLib()
    let userDefaults = UserDefaultsUtil()
    
    var url = NSURL() // 채팅서버 endpoint
    
    var isConnected = false
    var channelId: Int?
    var user: User?
    var roomType = ""
    var roomDestination = ""
    var header: [String:String]?
    
    // output
    var message = PublishSubject<(MockMessage, ReceivedMessageType)>()
    
    
    // MARK: 채팅 서버 준비 (헤더 값, 유저 정보)
    func setup() {
        let user = userDefaults.getUserInfo()
        self.user = user!
        
        self.header = [
            "access-token": userDefaults.getUserToken(),
            "user-id": "\(user!.id)",
        ]
    }
    
    // MARK: 채팅 서버 연결
    func register() {
        let chatServerId = userDefaults.getChatURL()
        let completedWSURL = "\(chatServerId)/my-chat/websocket"
        
        url = NSURL(string: completedWSURL)!
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: header)
    }
    
    func joinChannel(channelId: Int?, isGroup: Bool?) {
        var channel_Id: String?
        
        if (isGroup == nil) {
            channel_Id = "home"
        } else {
            if (isGroup!) {
                channel_Id = "r"
            } else {
                channel_Id = "c"
            }
            channel_Id = "\(channel_Id)-\(channelId!)"
        }
        
        let payloadObject = [
            "user_Id": "\(user!.id)",
            "type": "state",
            "channel_Id": "\(channel_Id!)"
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-\(roomType)-delete")
    }
    
    // MARK: 채널(방) 구독
    func connect(channelId: Int, isGroup: Bool) {
        // MARK: 채팅방 입장 시 상태 값 변경 (join channel)
        
        self.channelId = channelId
        roomType = isGroup ? "grop" : "direct"
        roomDestination = isGroup ? "channel" : "direct"
        
        let destination = "/topic/\(roomDestination)/\(channelId)"
        socketClient.subscribe(destination: destination)
        
        print("socket subscribe - \(destination)")
        self.isConnected = true
    }
    
    // MARK: 채널(방) 구독 취소
    func disconnect() {
        guard let channelId = self.channelId else {
            return
        }
        
        let destination = "/topic/\(roomDestination)/\(channelId)"
        socketClient.unsubscribe(destination: destination)
        print("socket unsubscribe - \(destination)")
        self.isConnected = false
    }
    
    func autoReconnect(){
        socketClient.autoDisconnect(time: 3)
        socketClient.reconnect(request: NSURLRequest(url: url as URL), delegate: self, time: 4.0)
    }
    
    // MARK: 채팅 메시지 보내기
    func sendMessage(message: String, communityId: Int?) {
        var payloadObject = [
            "content": message,
            "channelId": "\(channelId!)",
            "userId": "\(user!.id)",
            "name": "\(user!.name)",
            "profileImage": user!.profileImage as Any
        ] as [String : Any]
        
        if communityId != nil {
            payloadObject["communityId"] = communityId
        }
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-\(roomType)-message")
    }
    
    // MARK: 채팅 메시지 삭제
    func deleteMessage(message: MockMessage) {
        let payloadObject = [
            "id": message.messageId,
            "userId": "\(message.user.senderId)",
            "type": "delete",
            "channelId": "\(self.channelId!)"
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-\(roomType)-delete")
    }
    
    // MARK: 채팅 메시지 수정
    func modifyMessage(message: MockMessage) {
        var content: String = ""
        switch message.kind {
        case .text(let text):
            content = text
        default:
            break
        }
        
        let payloadObject = [
            "id": message.messageId,
            "content": content,
            "userId": user!.id,
            "type": "modify",
            "channelId": "\(String(describing: channelId))"
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-\(roomType)-modify")
    }
    
    // MARK: 채널(방) 구독
    func typing() {
        guard let user = self.user else {
            return
        }
        
        let payloadObject = [
            "content": "\(user.name)",
            "type": "typing",
            "channelId": "\(String(describing: channelId))"
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-\(roomType)-typing")
    }
    
    // MARK: 커뮤니티 입장 시그널링
    func communitySignaling(communityId: Int) {
        let payloadObject = [
            "user_id": "\(user!.id)",
            "type": "before-enter",
            "community_id": "\(String(describing: communityId))"
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/community-signaling")
        print("send communitySignaling \(communityId)")
    }
    
    func receiveMessageDecoder(stringBody: String?) -> MockMessage {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let messagePayload = try! decoder.decode(MessagePayload.self, from: stringBody!.data(using: .utf8)!)
        
        var newMessage = MockMessage()
        let user =  MockUser(senderId: messagePayload.userId,
                             displayName: messagePayload.name,
                             profileImage: messagePayload.profileImage)
        let date = messagePayload.time.ISOtoDate
        
        switch messagePayload.fileType {
        case .reply: break // 답글
        case .image: // 이미지
            let data = try! Data(contentsOf: URL(string: messagePayload.message)!)
            let payloadImg = UIImage(data: data)
            newMessage = MockMessage(
                image: payloadImg!,
                user: user, messageId: messagePayload.id, date: date)
        case .video: break // 비디오
        case .file: break // 파일
        case .none, .some: // 텍스트
            newMessage = MockMessage(
                text: messagePayload.message,
                user: user,
                messageId: messagePayload.id,
                date: date)
        }
        
        return newMessage
    }
}


// MARK: - StompClient Delegate
extension ChatWebSocketService: StompClientLibDelegate {
    // MARK: - 소켓으로 받은 메시지들 처리
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
        
        let type = jsonBody!["type"] as! String
        
        if (type != "connect" && type != "disconnect") {
            let type = ReceivedMessageType(rawValue: jsonBody!["type"] as! String)
            
            switch type {
            case .message: // (일반) 채팅 메시지
                let newMessage = self.receiveMessageDecoder(stringBody: stringBody)
                self.message.onNext((newMessage, .message))
                
            case .modify: // 메시지 수정
                var newMessage = MockMessage()
                newMessage.messageId = jsonBody!["id"] as! String
                newMessage.kind = MessageKind.text(jsonBody!["message"] as! String)
                newMessage.sentDate = (jsonBody!["time"] as! String).ISOtoDate
                self.message.onNext((newMessage, .modify))
            case .delete: // 메시지 삭제
                var newMessage = MockMessage()
                newMessage.messageId = jsonBody!["id"] as! String
                self.message.onNext((newMessage, .delete))
            case .reply: // 메시지 답장
                var newMesage = self.receiveMessageDecoder(stringBody: stringBody)
                newMesage.messageId = jsonBody!["id"] as! String
                self.message.onNext((newMesage, .reply))
            case .typing: // 메시지 입력 중
                var newMesage = MockMessage()
                newMesage.kind = MessageKind.text(jsonBody!["name"] as! String)
                self.message.onNext((newMesage, .typing))
            case .none:
                let newMessage = self.receiveMessageDecoder(stringBody: stringBody)
                self.message.onNext((newMessage, .message))
            }
        }
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
