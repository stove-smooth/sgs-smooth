//
//  MessageAppearance.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/05.
//

import Foundation
import MessageKit

// MARK: - Messages
extension ChattingViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white!
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention:
            if isFromCurrentSender(message: message) {
                return [.foregroundColor: UIColor.white!]
            } else {
                return [.foregroundColor: UIColor.blurple!]
            }
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .clear
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.prepareForInterfaceBuilder()
        
        // 프로필 셋업
        let user = self.messageList[indexPath.section].user
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        img.contentMode = .scaleAspectFit
        
        if user.profileImage != nil {
            img.kf.indicatorType = .activity
            img.setImage(URL(string: user.profileImage!)!)
        } else {
            img.image = UIImage(named: "Logo")
            img.center = CGPoint(x: 15 , y: 15)
            img.contentMode = .scaleAspectFit
        }
        avatarView.set(avatar: Avatar(image: img.image, initials: ""))
        
        avatarView.backgroundColor = UIColor.random(code: Int(user.senderId) ?? 0)
        avatarView.isHidden = isPreviousMessageSameSender(at: indexPath)
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.kf.cancelDownloadTask()
        }
    }
    
}

// MARK: - MessagesLayoutDelegate
extension ChattingViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if !isPreviousMessageSameSender(at: indexPath) {
            switch message.kind {
            case .photo:
                return 30
            default: return 20
            }
        } else {
            switch message.kind {
            case .text:
                return -20
            default:
                return 0
            }
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        switch message.kind {
        case .photo:
            return 16
        default:
            return 0
        }
    }
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
}
