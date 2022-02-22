//
//  EditProfileView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/15.
//

import UIKit

class EditProfileView: BaseView {
    var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
        
        $0.backgroundColor = .blurple
        $0.layer.cornerRadius = 5
    }
    
    let imgUploadButton = UIButton().then {
        $0.imageView?.layer.cornerRadius = 40
        $0.backgroundColor = .blurple
        $0.layer.cornerRadius = 40
        $0.contentMode = .scaleToFill
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
    
    let bioLabel = UILabel().then {
        $0.text = "내 소개"
        $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        $0.textColor = UIColor.textDescription
    }
    
    let bioLabelField = InputTextField().then {
        $0.keyboardType = .default
        
        $0.textColor = .white
        $0.backgroundColor = UIColor.serverListDarkGray
        
        $0.returnKeyType = .next
        $0.layer.cornerRadius = 5
        $0.clearButtonMode = .whileEditing
    }
    
    override func setup() {
        self.backgroundColor = UIColor.backgroundDarkGray
        
        [
            saveButton,
            imgUploadButton, uploadIcon,
            bioLabel, bioLabelField
        ].forEach {self.addSubview($0)}
        
        imgUploadButton.addSubview(textView)
    }
    
    override func bindConstraints() {
        saveButton.snp.makeConstraints {
            $0.top.equalTo(bioLabelField.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
        }
        
        imgUploadButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(15)
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
        
        bioLabel.snp.makeConstraints {
            $0.top.equalTo(imgUploadButton.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(15)
        }
        
        bioLabelField.snp.makeConstraints {
            $0.top.equalTo(bioLabel.snp.bottom).offset(10)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview().inset(15)
        }
    }
    
    func bind(user: User) {
        if user.profileImage != nil {
            let imgView = UIImageView().then {
                $0.setImage(URL(string: user.profileImage!)!)
            }
            imgUploadButton.setImage(imgView.image, for: .normal)
            textView.isHidden = true
        } else {
            textView.isHidden = false
            textView.text = "\(user.name)"
        }
        bioLabelField.text = user.bio
    }
    
    func upload(image: UIImage?) {
        self.imgUploadButton.setImage(image!, for: .normal)
        self.textView.isHidden = true
    }
}
