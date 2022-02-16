//
//  ChattingView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/05.
//

import MessageKit

extension ChattingViewController {
    
    // MARK: - NavigationController
    func configureNavigationController(channelId: Int?) {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Menu")?.resizeImage(size: CGSize(width: 25, height: 25)),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton)
        )
        
        let titleImgView = UIImageView().then {
            $0.image = UIImage(named: "Channel+text")?.resizeImage(size: CGSize(width: 20, height: 20))
        }
        let titleLabel = UILabel().then{
            $0.textColor = .white
        }
        
        titleLabel.text = "채팅 없음"
        
        let titleView = UIStackView().then {
            $0.distribution = .fill
            $0.axis = .horizontal
        }
        let spacer = UIView()
        let constraint = spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.greatestFiniteMagnitude)
        constraint.isActive = true
        constraint.priority = .defaultLow
        
        [titleImgView, titleLabel, spacer].forEach { titleView.addArrangedSubview($0)}
        
        navigationItem.titleView = titleView
    }
    
    // MARK: - Collection
    func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        setMessageCollectionLayout()
    }
    
    func setMessageCollectionLayout() {
        messagesCollectionView.refreshControl = refreshControl
        messagesCollectionView.backgroundColor = .messageBarDarkGray
        messagesCollectionView.tintColor = .clear
        
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        // 메시지 내용 (topLabel, 이름)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)))
        
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAvatarPosition(.init(vertical: .cellTop))
        layout?.setMessageIncomingAvatarPosition(.init(vertical: .cellTop))
    }
    
    // MARK: - InputBar
    func configureMessageInputBar() {
        messageInputBar = CameraInputBarAccessoryView()
        messageInputBar.delegate = self
        
        messageInputBar.sendButton.setTitleColor(
            UIColor.blurple!.withAlphaComponent(0.3),
            for: .highlighted)
        
        configureInputBarItems()
    }
    
    func configureInputBarItems() {
        messageInputBar.inputTextView.placeholder = "메시지를 입력해주세요"
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 88/255, green: 101/255, blue: 242/255, alpha: 0.3)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets.all(2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "Paperplane")
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        
        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = .blurple
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = UIColor(red: 88/255, green: 101/255, blue: 242/255, alpha: 0.3)
                })
            }
    }
    
    func configureInputBarPadding() {
        messageInputBar.middleContentViewPadding.right = -38
        
        // Entire InputBar padding
        messageInputBar.padding.bottom = 8
        // or InputTextView padding
        messageInputBar.inputTextView.textContainerInset.bottom = 8
    }
}
