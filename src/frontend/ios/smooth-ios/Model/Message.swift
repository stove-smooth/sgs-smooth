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
    let thumbnail: String?
    let fileType: FileType?
    let type: RoomType?
    let time: String
    
    let parentId: String?
    let parentName: String?
    let parentContent: String?
}

struct MessagePayload: Codable {
    let id: String
    let name: String
    let userId: String

    let profileImage: String?
    let message: String
    
    let originImage: String?
    let fileType: FileType?

    let time: String
}

enum RoomType: String, Codable{
    case community = "community"
    case direct = "dircet"
}

enum FileType: String, Codable {
    case image = "image"
    case video = "video"
    case file = "file"
    case reply = "reply"
}

struct FileMessageRequest: Codable {
    let image: Data?
    let thumbnail: Data?
    let userId: Int
    let channelId: Int
    let communityId: Int?
    let type: String
    let fileType: FileType
    let name: String
    let profileImage: String?
}
