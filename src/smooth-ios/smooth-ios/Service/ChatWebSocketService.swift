//
//  ChatWebSocketService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import Foundation
import StompClientLib

class ChatWebSocketService: NSObject {
    var delegate: StompClientLibDelegate?
    
    let socketClient = StompClientLib()
    
    let baseURL = "http://3.36.238.237:8080"
    var url = NSURL()
    var channelId: Int?
    var userId: Int?
    
    var header: [String: String] = [:]
    private var reconnectTimer : Timer?
    public var connection: Bool = false
    
    func setup() {
        let userDefaults = UserDefaultsUtil()
        guard let user = userDefaults.getUserInfo() else { return }
        
        self.userId = user.id
        self.header = [
            "access-token": userDefaults.getUserToken(),
            "user-id": "\(userId!)",
            "heart-beat": "10000,10000"
        ]
    }
    
    func register(channelId: Int) {
        self.setup()
        self.channelId = channelId
        
        let wsURL = baseURL[baseURL.index(baseURL.startIndex, offsetBy: 7)...]
         let completedWSURL = "ws://\(wsURL)/my-chat/websocket"
    
        url = NSURL(string: completedWSURL)!
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self.delegate! , connectionHeaders: self.header)
        
        /*
        print(self.header)
        print(self.url)
        
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url as URL),
            delegate: self,
            connectionHeaders: self.header
        )
        
        self.connection = true
        */
    }
    
    func connect() {
        guard let channelId = self.channelId else {
            return
        }
        
        let destination = "/topic/group/\(channelId)"
        
        socketClient.subscribeWithHeader(destination: destination, withHeader: self.header)
    }
    
    func disconnect() {
        guard let channelId = self.channelId else {
            return
        }
        
        self.connection = false
        socketClient.unsubscribe(destination: "/topic/group/\(channelId)")
        socketClient.disconnect()
    }
    
    func autoReconnect(){
        socketClient.autoDisconnect(time: 3)
        socketClient.reconnect(request: NSURLRequest(url: url as URL), delegate: self.delegate!, time: 4.0)
    }
    
    func sendMessage(message: String) {
        let socketMessage = SocketMessage(content: message, channelId: "\(channelId!)", accountId: "\(userId!)")
        
        let data = try! JSONEncoder().encode(socketMessage)
        
        print("socket isConnected() \( socketClient.isConnected())")
        
        guard let channelId = channelId else {
            return
        }

        guard let userId = userId else {
            return
        }

        let payloadObject = [
            "content": message,
            "channelId": String(describing: channelId),
            "accountId": String(describing: userId)
        ] as [String : Any]
        
        socketClient.sendJSONForDict(dict: payloadObject as AnyObject, toDestination: "/kafka/send-channel-message")
    }
}
