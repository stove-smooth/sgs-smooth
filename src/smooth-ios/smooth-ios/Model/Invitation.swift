//
//  Invitation.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import Foundation


struct Invitation: Codable {
    let id: Int
    let nickname: String
    let userCode: String
    let profileImage: String?
    let inviteCode: String
    
    enum CodingKeys: String, CodingKey {
        case nickname, userCode, profileImage, inviteCode
        case id = "invitationId"
    }
}


struct InvitaionList: Codable {
    let invitations: [Invitation]
}
