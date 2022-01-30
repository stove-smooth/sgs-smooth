//
//  EditServerInfoView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class EditServerInfoView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "일반"
    }
    
    var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    let imgUploadButton = UIButton().then {
        $0.imageView?.layer.cornerRadius = 40
        $0.backgroundColor = .blurple
        $0.layer.cornerRadius = 40
        
    }
    
    let uploadIcon = UIImageView().then {
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        img.image = UIImage(named: "Image+Upload")
        img.center = CGPoint(x: 15, y: 15)
        
        $0.addSubview(img)
    }
    
    let textView = UILabel().then {
        $0.textColor = .white
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
    }
    
    let deleteButton = UIButton().then {
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 5
        
        $0.setTitle("서버 삭제", for: .normal)
        $0.titleLabel?.textColor = .white
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [closeButton, naviTitleLabel, saveButton].forEach {navigationView.addSubview($0)}
        
        [
            navigationView,
            imgUploadButton, uploadIcon,
            serverNameLabel, serverNameLabelField,
            deleteButton
        ].forEach {self.addSubview($0)}
        
        imgUploadButton.addSubview(textView)
    }
    
    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview()
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview()
        }
        
        imgUploadButton.snp.makeConstraints {
            $0.top.equalTo(naviTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.height.equalTo(80)
        }
        
        uploadIcon.snp.makeConstraints {
            $0.right.equalTo(imgUploadButton.snp.right)
            $0.top.equalTo(imgUploadButton.snp.top)
            $0.width.height.equalTo(30)
        }
        
        textView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        serverNameLabel.snp.makeConstraints {
            $0.top.equalTo(imgUploadButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
        }
        
        serverNameLabelField.snp.makeConstraints {
            $0.top.equalTo(serverNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(serverNameLabelField.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    func bind(server: Server) {
        if server.icon != nil {
            let imgView = UIImageView().then {
                $0.setImage(URL(string: server.icon!)!)
            }
            imgUploadButton.setImage(imgView.image, for: .normal)
            textView.isHidden = true
        } else {
            textView.isHidden = false
            textView.text = "\(server.name)"
        }
        serverNameLabelField.text = server.name
    }
    
    func upload(image: UIImage?) {
        self.imgUploadButton.setImage(image!, for: .normal)
        self.textView.isHidden = true
    }
}
