//
//  CustomCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/02.
//

import UIKit
import InputBarAccessoryView

protocol  CameraInputBarAccessoryViewDelegate : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment])
}

extension CameraInputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment]){
    }
}

class CameraInputBarAccessoryView: InputBarAccessoryView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    func layout() {
        self.backgroundView.backgroundColor = .serverListDarkGray
        
        self.inputTextView.tintColor = .blurple
        self.inputTextView.textColor = .white
        self.inputTextView.backgroundColor = .serverListDarkGray
        self.isTranslucent = true
        self.separatorLine.isHidden = true
        
        self.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        self.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        self.inputTextView.layer.cornerRadius = 10.0
        self.inputTextView.layer.masksToBounds = true
        self.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    func configure(){
        let camera = makeButton(named: "ic_camera")
        camera.tintColor = .darkGray
        camera.onTouchUpInside { [weak self] item in
            self?.showImagePickerControllerActionSheet()
        }
        self.setLeftStackViewWidthConstant(to: 35, animated: true)
        self.setStackViewItems([camera], forStack: .left, animated: false)
        self.inputPlugins = [attachmentManager]
    }
    
    override func didSelectSendButton() {
        if attachmentManager.attachments.count > 0 {
            (delegate as? CameraInputBarAccessoryViewDelegate)?.inputBar(self, didPressSendButtonWith: attachmentManager.attachments)
        }
        else {
            delegate?.inputBar(self, didPressSendButtonWith: inputTextView.text)
        }
    }
    
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                
                if #available(iOS 13.0, *) {
                    $0.image = UIImage(systemName: "camera.fill")?.withRenderingMode(.alwaysTemplate)
                } else {
                    $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                }
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected {
                $0.tintColor = .iconDefault
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
            }
    }
    
}


extension CameraInputBarAccessoryView : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @objc  func showImagePickerControllerActionSheet()  {
        let photoLibraryAction = UIAlertAction(title: "사진 선택하기", style: .default) { [weak self] action in
            self?.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "카메라로 사진찍기", style: .default) { [weak self] action in
            self?.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel , handler: nil)
        
        AlertUtils.showAlert(style: .actionSheet, title: "사진 업로드 방법을 선택해주세요", message: nil, actions: [photoLibraryAction, cameraAction , cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.sourceType = sourceType
        imgPicker.presentationController?.delegate = self
        inputAccessoryView?.isHidden = true
        getRootViewController()?.present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[  UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // self.sendImageMessage(photo: editedImage)
            self.inputPlugins.forEach { _ = $0.handleInput(of: editedImage)}
            
        }
        else if let originImage = info[  UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.inputPlugins.forEach { _ = $0.handleInput(of: originImage)}
            //self.sendImageMessage(photo: originImage)
        }
        getRootViewController()?.dismiss(animated: true, completion: nil)
        inputAccessoryView?.isHidden = false
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        getRootViewController()?.dismiss(animated: true, completion: nil)
        inputAccessoryView?.isHidden = false
    }
    
    func getRootViewController() -> UIViewController? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController
    }
}


extension CameraInputBarAccessoryView: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        self.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        self.showImagePickerControllerActionSheet()
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        let topStackView = self.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}


extension CameraInputBarAccessoryView: UIAdaptivePresentationControllerDelegate {
    // Swipe to dismiss image modal
    public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        isHidden = false
    }
}
