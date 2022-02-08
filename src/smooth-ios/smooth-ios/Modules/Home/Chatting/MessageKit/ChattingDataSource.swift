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
        
        let user = messageList[indexPath.section].user
        self.coordinator?.showFriendInfoModal(id: Int(user.senderId)!, state: .none)
    }
    

    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        
        self.coordinator?.showMessageOptionModal(indexPath: indexPath)
        
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        // 이미지 크게 보기
    }
    
    func didTapBackground(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        messagesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        
        self.coordinator?.showMessageOptionModal(indexPath: indexPath)
    }
}
