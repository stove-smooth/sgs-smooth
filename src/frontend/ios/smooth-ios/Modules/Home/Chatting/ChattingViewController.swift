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
import Toast_Swift

protocol ChattingViewControllerDelegate: AnyObject {
    func didTapMenuButton(channelId: Int?, communityId: Int?)
    func dismiss(channelId: Int?, communityId: Int?)
}

class ChattingViewController: MessagesViewController {
    let disposeBag = DisposeBag()
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ChattingViewControllerDelegate?
    
    private let emptyView = ChannelEmptyView()
    private let editInputAccessoryView = EditInputBarAccessoryView()
    
    internal let viewModel: ChattingViewModel
    
    var messageList: [MockMessage] = []
    
    static func instance() -> ChattingViewController {
        return ChattingViewController()
    }
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let user = UserDefaultsUtil().getUserInfo()!
        let messageUser = MockUser(senderId: "\(user.id)", displayName: user.name, profileImage: user.profileImage)
        
        self.viewModel = ChattingViewModel(
            messageUser: messageUser,
            chattingService: ChattingService(),
            chatWebSocketService: appDelegate?.coordinator?.chatWebSocketService as! ChatWebSocketService
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.messageInputBar.isHidden = false
        delegate?.dismiss(channelId: self.viewModel.model.channel.0, communityId: self.viewModel.model.communityId)
        
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController(channelId: nil, channelName: "채팅 없음")
        configureMessageCollectionView()
        configureMessageInputBar()
        
        // VC <-> VM
        bindEvent()
        bindViewModel()
    }
    
    // MARK: 메시지 불러오기
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton(channelId: self.viewModel.model.channel.0, communityId: self.viewModel.model.communityId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.dismiss(channelId: self.viewModel.model.channel.0, communityId: self.viewModel.model.communityId)
        
        super.viewWillDisappear(animated)
    }
    
    func bindEvent() {
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        // MARK: - Model Binding
        // input
        self.messageInputBar.inputTextView.rx.text
            .asDriver()
            .debounce(.seconds(3))
            .drive(onNext: { value in
                self.viewModel.input.inputMessage.onNext(value)
            })
            .disposed(by: disposeBag)
            
        // output
        self.viewModel.output.channel
            .bind(onNext: { (channelId, channelName) in
                self.viewModel.input.fetch.onNext((channelId, nil))
                self.viewModel.model.channel = (channelId, channelName)
                self.viewModel.model.page = 0
                self.configureNavigationController(channelId: channelId, channelName: channelName)
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem()
                //                self.messageInputBar.inputTextView.placeholder = "#\(channel.name)에 메시지 보내기"
            }).disposed(by: disposeBag)
            
        self.viewModel.output.messages
            .asDriver(onErrorJustReturn: ([], nil))
            .drive { (messages, type) in
                switch type {
                case .message, .delete, .modify:
                    self.messageList = messages
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                    if(self.viewModel.model.page == 0) {
                        self.messagesCollectionView.scrollToLastItem()
                    }
                case .reply: break
                case .typing: break
                case .none:
                    self.messageList.insert(contentsOf: messages, at: 0)
                    self.messagesCollectionView.reloadDataAndKeepOffset()
                    self.refreshControl.endRefreshing()
                    if(self.viewModel.model.page == 0) {
                        self.messagesCollectionView.scrollToLastItem()
                    }
                }
            }.disposed(by: disposeBag)

        
        // MARK: - Toast Popup
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.output.showEmpty
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [self] isEmpty in
                if (isEmpty) {
                    view.addSubview(emptyView)
                    emptyView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                    }
                } else {
                    emptyView.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showToast(message: String, isWarning: Bool) {
        var style = ToastStyle()
        style.backgroundColor = .serverListDarkGray!
        style.cornerRadius = 15
        
        let emoji = isWarning ? "⛔️ " : "✅ "
        
        self.view.makeToast(
            emoji+message,
            position: .top,
            style: style
        )
    }
}

// MARK: - HomeVC Delegate
extension ChattingViewController: HomeViewControllerDelegate {
    func loadChatting(_ chatName: String, channelId: Int, communityId: Int?) {
        self.messageList = []
        self.viewModel.model.page = 0
        self.viewModel.input.disappear.onNext(())
        self.viewModel.model.communityId = communityId
        self.viewModel.output.channel.accept((channelId, chatName))
    }
}

// MARK: - Message
extension ChattingViewController {
    
    // MARK: 메시지 불러오기
    @objc func loadMoreMessages() {
        self.viewModel.input.fetch.onNext((self.viewModel.model.channel.0, self.viewModel.model.page))
    }
    
    // MARK: 메시지 보내기
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
        self.viewModel.input.socketMessage.onNext((messageList[indexPath.section], .delete))
        
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
                self?.messagesCollectionView
                    .scrollToLastItem(animated: true)
            } else {
                self?.messagesCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
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
extension ChattingViewController: InputBarAccessoryViewDelegate, CameraInputBarAccessoryViewDelegate {
    @objc
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment]) {
        for item in attachments {
            if  case .image(let image) = item {
                self.insertMessages([image])
            }
        }
        inputBar.invalidatePlugins()
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
        
        
        func modifyInputBar(indexPath: IndexPath) {
            let message = messageList[indexPath.section]
            
            var content: String = ""
            switch message.kind {
            case .text(let text):
                content = text
            default: break
            }
            
            inputBar.inputTextView.text = content
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "메시지 보내는 중..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        
        DispatchQueue.global(qos: .default).async {
            sleep(UInt32(0.2)) // fake send request task
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
            // MARK: 텍스트
            if let str = component as? String {
                let message = MockMessage(
                    kind: .text(str),
                    user: self.viewModel.model.messageUser,
                    messageId: UUID().uuidString,
                    date: Date()
                )
                
                self.viewModel.input.socketMessage.onNext((message, .message))
                insertMessage(message)
            }
            // MARK: 이미지
            else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: self.viewModel.model.messageUser, messageId: UUID().uuidString, date: Date())
                
                self.viewModel.input.socketMessage.onNext((message, .message))
                insertMessage(message)
            }
        }
    }
}
