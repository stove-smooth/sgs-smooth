//
//  ChattingDataSource.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/05.
//

import Foundation
import MessageKit

extension ChattingViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return MockUser(senderId: "-1", displayName: "test")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.white!
            ])
        }
        return nil
    }
}

// MARK: - MessageCellDelegate
extension ChattingViewController: MessageCellDelegate {
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        messagesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        
        #warning("message mockup으로 유저 데이터 얻기 & 내 프로필 선택 시 내 정보 보여주기")
        // let friend = messageList[indexPath.section]
        
        let friend = Friend(id: 2, name: "밍디", code: "1374", profileImage: Optional("https://sgs-smooth.s3.ap-northeast-2.amazonaws.com/1643090865999"), state: .accept)
         self.coordinator?.showFriendInfoModal(friend: friend)
    }
    

    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        messagesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    
//        self.deleteMessage(indexPath)
    }
}
