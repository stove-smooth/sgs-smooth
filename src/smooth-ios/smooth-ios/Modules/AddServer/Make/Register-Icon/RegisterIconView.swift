//
//  RegisterIconView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit
import Photos

class RegisterIconView: BaseView {
    let titleLabel = UILabel().then {
        $0.text = "서버를 만들어보세요"
        $0.textColor = .white
        $0.font = UIFont.GintoNord(type: .Bold, size: 22)
    }
    
    let titleDescriptionLabel = UILabel().then {
        $0.text = "서버는 나와 친구들이 함께 어울리는 공간입니다.\n내 서버를 만들고 대화를 시작해보세요."
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .ultraLight)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    let uploadButton = UIButton().then {
        $0.imageView?.layer.cornerRadius = 40
        $0.setImage(UIImage(named: "Server+Photo"), for: .normal)
    }
    
    let serverNameLabel = UILabel().then {
        $0.text = "서버 이름"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let serverNameLabelField = InputTextField().then {
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
        $0.text = "두리님의 서버"
    }
    
    let registerButton = UIButton().then {
        $0.setTitle("서버 만들기", for: .normal)
        $0.backgroundColor = UIColor.blurple
        $0.layer.cornerRadius = 5
    }
    
    var imageView = UIImageView().then {
        $0.backgroundColor = .blurple
    }
    
    
    override func setup() {
        self.backgroundColor = .backgroundDarkGray
        [
            titleLabel, titleDescriptionLabel, uploadButton,
            serverNameLabel, serverNameLabelField, registerButton
        ].forEach { self.addSubview($0) }
    }
    
    override func bindConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
        }
        
        titleDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        uploadButton.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.height.equalTo(80)
        }
        
        serverNameLabel.snp.makeConstraints {
            $0.top.equalTo(uploadButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
        }
        
        serverNameLabelField.snp.makeConstraints {
            $0.top.equalTo(serverNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(serverNameLabelField.snp.bottom).offset(15)
            $0.height.equalTo(50)
            $0.left.right.equalTo(serverNameLabelField)
        }
    }
    
    func bind(image: UIImage?) {
        self.uploadButton.setImage(image, for: .normal)
    }
}
