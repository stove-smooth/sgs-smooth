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
    func didTapMenuButton(channel: Channel?, communityId: Int?)
}

class ChattingViewController: MessagesViewController {
    let disposeBag = DisposeBag()
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ChattingViewControllerDelegate?
    
    private let viewModel: ChattingViewModel
    
    lazy var messageList: [MockMessage] = []
    let messageUser: MockUser
    
    var channel: Channel?
    var communityId: Int?
    var inputBarisHide = false
    
    static func instance() -> ChattingViewController {
        return ChattingViewController()
    }
    
    init() {
        self.viewModel = ChattingViewModel(
            chattingService: ChattingService()
        )
        let user = UserDefaultsUtil().getUserInfo()!
        self.messageUser = MockUser(senderId: "\(user.id)", displayName: user.name)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController(channel: nil)
        configureMessageCollectionView()
        configureMessageInputBar()
        
        bindViewModel()
    }
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton(channel: nil, communityId: nil)
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
        
        self.viewModel.output.commniutyId
            .bind(onNext: { communityId in self.communityId = communityId })
            .disposed(by: disposeBag)
        
        self.viewModel.output.messages
            .bind(onNext: { messages in
                self.messageList = messages
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
            }).disposed(by: disposeBag)
        
    }
}

// MARK: - HomeVC Delegate
extension ChattingViewController: HomeViewControllerDelegate {
    func loadChatting(channel: Channel, communityId: Int?) {
        self.viewModel.output.channel.accept(channel)
        self.viewModel.output.commniutyId.accept(communityId)
    }
}

// MARK: - Message
extension ChattingViewController {

    
    @objc func loadMoreMessages() {
        self.viewModel.output.messages
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { messsages in
                self.messageList.insert(contentsOf: messsages, at: 0)
                self.messagesCollectionView.reloadDataAndKeepOffset()
                self.refreshControl.endRefreshing()
            }).disposed(by: self.disposeBag)
    }
    
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
    
    func deleteMessage(_ indexPath: IndexPath) {
        print("\(indexPath) \(messageList.count)")
        
        messagesCollectionView.performBatchUpdates({
            messageList.remove(at: indexPath.section)
            messagesCollectionView.deleteSections([indexPath.section])
            
            if isLastSectionVisible() {
                messagesCollectionView.reloadSections([indexPath.section-1])
            } else {
                messagesCollectionView.reloadSections([indexPath.section+1])
            }
        }, completion: {[weak self] _ in
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

// MARK: - InputBar
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
            if let str = component as? String {
                self.viewModel.sendMessage(message: str, communityId: self.communityId)
                let message = MockMessage(kind: MessageKind.text(str), user: messageUser, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
            else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: messageUser, messageId: UUID().uuidString, date: Date())
                
                let thumb = img.generateThumbnail()!
                
                let request = FileMessageRequest(
                    image: img.data,
                    thumbnail: thumb.data,
                    userId: Int(messageUser.senderId)!,
                    channelId: channel!.id,
                    communityId: communityId,
                    type: communityId != nil ? "community" : "direct",
                    fileType: FileType.image
                )
                
                self.viewModel.sendFileMessage(request: request)
                insertMessage(message)
            }
        }
    }
}
