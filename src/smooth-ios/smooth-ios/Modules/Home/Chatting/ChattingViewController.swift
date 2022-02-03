//
//  ContainerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import MessageKit
import InputBarAccessoryView

protocol ChattingViewControllerDelegate: AnyObject {
    func didTapMenuButton(channel: Channel?)
}

class ChattingViewController: MessagesViewController {
    let disposeBag = DisposeBag()
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ChattingViewControllerDelegate?
    
    private let viewModel: ChattingViewModel
    
    lazy var messageList: [MockMessage] = []
    var channel: Channel?
    var inputBarisHide = false
    
    static func instance() -> ChattingViewController {
        return ChattingViewController()
    }
    
    init() {
        self.viewModel = ChattingViewModel(chattingRepository: ChattingRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController(channel: nil)
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
        
        bindViewModel()
    }
    
    func configureNavigationController(channel: Channel?) {
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
        
        if channel != nil {
            titleImgView.image = UIImage(named: "Channel+\(channel!.type.rawValue.lowercased())")?.resizeImage(size: CGSize(width: 20, height: 20))
            titleLabel.text = channel!.name
        } else {
            titleLabel.text = "채팅 없음"
        }
        
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
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton(channel: nil)
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.refreshControl = refreshControl
        messagesCollectionView.backgroundColor = .messageBarDarkGray
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        layout?.setMessageOutgoingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 0)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)))
        
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 50, bottom: 15, right: 0)))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
        
        layout?.setMessageOutgoingAvatarPosition(.init(vertical: .cellTop))
        layout?.setMessageIncomingAvatarPosition(.init(vertical: .cellTop))
        
        layout?.setMessageIncomingMessagePadding(UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0))
        
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
    }
    
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
        
        // Entire InputBar padding
        messageInputBar.padding.bottom = 8
        
        // or MiddleContentView padding
        messageInputBar.middleContentViewPadding.right = -38
        
        // or InputTextView padding
        messageInputBar.inputTextView.textContainerInset.bottom = 8
        
    }
    
    private func bindViewModel() {
        self.viewModel.output.channel
            .bind(onNext: { channel in
                self.viewModel.input.fetch.onNext(channel)
                self.channel = channel
                self.configureNavigationController(channel: channel)
                self.messageInputBar.inputTextView.placeholder = "#\(channel.name)에 메시지 보내기"
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - load message
    func loadFirstMessages() {
        DispatchQueue.global(qos: .userInitiated).async {
            let count = UserDefaults.standard.mockMessagesCount()
            SampleData.shared.getMessages(count: count) { messages in
                DispatchQueue.main.async {
                    self.messageList = messages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
        }
    }
    
    @objc func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            SampleData.shared.getMessages(count: 20) { messages in
                DispatchQueue.main.async {
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: MockMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messageList.count else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section + 1].user
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messageList[indexPath.section].user == messageList[indexPath.section - 1].user
    }
}

extension ChattingViewController: HomeViewControllerDelegate {
    func loadChatting(channel: Channel) {
        self.viewModel.output.channel.accept(channel)
    }
}

extension ChattingViewController: MessagesLayoutDelegate {
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? (20 + 17.5) : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
}

extension ChattingViewController: InputBarAccessoryViewDelegate {
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "메시지 보내기"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = SampleData.shared.currentSender
            if let str = component as? String {
                let message = MockMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}


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
        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
        avatarView.isHidden = isPreviousMessageSameSender(at: indexPath)
    }
    
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        
        let shouldShow = Int.random(in: 0...10) == 0
        guard shouldShow else { return }
        
        let button = UIButton(type: .infoLight)
        button.tintColor = .blurple
        accessoryView.addSubview(button)
        button.frame = accessoryView.bounds
        button.isUserInteractionEnabled = false // respond to accessoryView tap through `MessageCellDelegate`
        accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.kf.cancelDownloadTask()
        }
    }
    
}

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
