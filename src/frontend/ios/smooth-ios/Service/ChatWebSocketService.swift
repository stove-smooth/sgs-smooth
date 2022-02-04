//
//  ChatWebSocketService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import Foundation
import StompClientLib

protocol ChatWebSocketServiceProtocol {
    func register()
    func disconnect()
    func connect(type: String, channelId: Int?)
    func autoReconnect()
}

class ChatWebSocketService: NSObject, StompClientLibDelegate, ChatWebSocketServiceProtocol {
    
    let socketClient = StompClientLib()
    
    let baseURL = "http://3.36.238.237:8080/my-chat"
    
    var url = NSURL()
    private var header: [String: String] = [:]
    private var reconnectTimer : Timer?
    public var connection: Bool = false
    
    override init() {
        let userDefaults = UserDefaultsUtil()
        guard let user = userDefaults.getUserInfo() else { return }
        
        self.header = [
            "access-token": userDefaults.getUserToken(),
            "user-id": "\(user.id)",
            "heart-beat": "0, 10000"
        ]
    }
    
    func register() {
        let wsURL = baseURL[baseURL.index(baseURL.startIndex, offsetBy: 7)...]
        let completedWSURL = "ws://\(wsURL)/websocket"
        
        url = NSURL(string: completedWSURL)!
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: self.header)
        print(header)
        print(url)
        self.connection = true
        
        print("Socket is connected successfully!")
    }
    
    func connect(type: String, channelId: Int?){
        var topic = "/topic/\(type)"
        
        if channelId != nil {
            topic = topic + "/" + "\(channelId!)"
        }

        
        print("Socket is topic Connected : \(topic)")
        
        socketClient.subscribeWithHeader(destination: topic, withHeader: header)
    }
    
    func disconnect() {
        self.connection = false
        socketClient.disconnect()
    }
    
    func autoReconnect(){
        socketClient.autoDisconnect(time: 3)
        socketClient.reconnect(request: NSURLRequest(url: url as URL), delegate: self as StompClientLibDelegate, time: 4.0)
    }
    
    func sendMessage() {
        let dict = ["content" :"test duri","channelId":"105","accountId":3] as [String : Any]
        
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dict) else { return }
        
        socketClient.sendMessage(
            message: String(data: dictionaries, encoding: .utf8)!,
            toDestination: "/kafka/send-channel-message",
            withHeaders: header,
            withReceipt: nil
        )
    }
    
    // MARK: - StompClient Delegate
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
        self.serverDidSendPing()
        client.autoDisconnect(time: 3)
        client.reconnect(request: NSURLRequest(url: url as URL) , delegate: self)
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        let topic = "/topic/group/105"
//        socketClient.subscribeWithHeader(destination: topic, withHeader: header)
        
        client.subscribeWithHeader(destination: topic, withHeader: header)
        
        print("Socket is Connected : \(topic)")
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
