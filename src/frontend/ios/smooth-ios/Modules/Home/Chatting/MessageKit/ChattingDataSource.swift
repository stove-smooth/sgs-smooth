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
        
        
        self.showMessageOption(indexPath: indexPath)
        
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        // 이미지 크게 보기
    }
    
    func didTapBackground(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        
        messagesCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        
        self.showMessageOption(indexPath: indexPath)
    }
}

extension ChattingViewController {
    func showMessageOption(indexPath: IndexPath) {
        UIAlertController.present(
            in: self, title: nil, message: nil,
            style: .actionSheet,
            actions: [
                .action(title: "메시지 수정하기", style: .default),
                .action(title: "메시지 삭제하기", style: .default),
                .action(title: "취소", style: .cancel)
            ]).subscribe(onNext: { index in
                switch index {
                case 0:
//                    self.modifyInputBar(indexPath)
                    break
                case 1:
                    self.showDeleteMessage(indexPath: indexPath)
                default:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func showDeleteMessage(indexPath: IndexPath) {
        AlertUtils.showWithCancel(
            controller: self,
            title: "메시지 삭제",
            message: "정말 이 메시지를 삭제할까요? 삭제하면 되돌릴 수 없어요."
        ) {
            self.deleteMessage(indexPath)
        }
    }
}
