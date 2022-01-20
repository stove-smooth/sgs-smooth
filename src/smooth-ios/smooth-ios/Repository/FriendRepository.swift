//
//  FriendRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import Foundation
import Moya
import RxSwift

struct FriendRepository: Networkable {
    let disposeBag = DisposeBag()
    
    typealias Target = FriendTarget
    
    static func fetchFriend(_ completion: @escaping ([FriendSection]?, Error?) -> Void) {
        makeProvider().request(.fetchFriend) { result in
            switch BaseResponse<FriendListResponse>.processJSONResponse(result) {
            case .success(let responses):
                guard let responses = responses else { return }
                
                var section: [FriendSection] = []
                
                // TODO: 하드코딩한거 리팩토링 해야함
                let friendList = responses.result
                    .filter { $0.state == .accept }
                    .map { FriendCellType.normal($0) }
                
                if friendList.count > 0 {
                    section.append(FriendSection(header: "친구", items: friendList))
                }
                
                let waitList = responses.result
                    .filter { $0.state == .wait || $0.state == .request }
                    .map { FriendCellType.normal($0) }
                
                if waitList.count > 0 {
                    section.append(FriendSection(header: "수락 대기 중", items: waitList))
                }
                return completion(section, nil)
                
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    static func deleteFriend(_ request: DeleteFriendRequest, _ completion: @escaping (DeleteFriendResponse?, Error?) -> Void) {
        makeProvider().request(.deleteFriend(param: request)) { result in
            switch BaseResponse<DeleteFriendResponse>.processJSONResponse(result) {
            case .success(let responses):
                return completion(responses, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}
