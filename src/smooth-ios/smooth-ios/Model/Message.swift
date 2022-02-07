//
//  Message.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import MessageKit

struct Message: Codable {
    let id: String
    let name: String
    let profileImage: String?
    let userId: Int
    let message: String
    let time: String
    let parentName: String?
    let parentContent: String?
}

struct SocketMessage: Codable {
    let content: String
    let channelId: String
    let accountId: String
}

struct MessagePayload: Codable {
    let message: String
    let userId: String
    let name: String
    let profileImage: String?
}

enum RoomType: String, Codable{
    case community = "community"
    case direct = "dircet"
}

enum FileType: String, Codable {
    case image = "image"
    case video = "video"
    case file = "file"
}

struct FileMessageRequest: Codable {
    let image: Data?
    let thumbnail: Data?
    let userId: Int
    let channelId: Int
    let communityId: Int?
    let type: String
    let fileType: FileType
}
