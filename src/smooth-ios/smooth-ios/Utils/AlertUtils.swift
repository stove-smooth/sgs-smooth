//
//  AlertUtils.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

struct AlertUtils {
    static func show(controller: UIViewController? = nil, title: String? = nil, message: String? = nil) {
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        show(parentController: controller, title: title, message: message, [confirm])
    }
    
    static func showWithCancel(controller: UIViewController? = nil, title: String? = nil, message: String? = nil) {
      let okAction = UIAlertAction(title: "확인", style: .default)
      let cancelAction = UIAlertAction(title: "취소", style: .cancel)
      
      show(parentController: controller, title: title, message: message, [okAction, cancelAction])
    }
    
    static func show(parentController: UIViewController? = nil, title: String?, message: String?, _ actions: [UIAlertAction]) {
      let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      for action in actions {
        controller.addAction(action)
      }
      if parentController != nil {
        parentController?.present(controller, animated: true)
      } else {
        if let delegate = UIApplication.shared.connectedScenes.first?.delegate as? AppDelegate,
           let rootVC = delegate.window?.rootViewController {
          rootVC.present(controller, animated: true)
        }
      }
    }
    
    static func showWithCancel(
      controller: UIViewController,
      title: String? = nil,
      message: String? = nil,
      okButtonTitle: String? = "확인",
      onTapOk: @escaping () -> Void
    ) {
      let okAction = UIAlertAction(title: okButtonTitle, style: .default) { (action) in
        onTapOk()
      }
      let cancelAction = UIAlertAction(title: "취소", style: .cancel)
      
      show(controller: controller, title: title, message: message, [okAction, cancelAction])
    }
    
    static func show(
      controller: UIViewController,
      title: String?,
      message: String?,
      _ actions: [UIAlertAction]
    ) {
      let alrtController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      for action in actions {
        alrtController.addAction(action)
      }
      controller.present(alrtController, animated: true)
    }
    
}
