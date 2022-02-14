//
//  ServerCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/09.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class ServerCell: BaseTableViewCell {
    static let identifier = "\(ServerCell.self)"
    
    let serverImg = UIImageView().then {
        $0.backgroundColor = .messageBarDarkGray
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let selectedView = UIView().then {
        $0.layer.contents = 20
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    let textView = UILabel().then {
        $0.textColor = .white
    }
    
    let alertBadge = UIView().then {
        $0.backgroundColor = .red
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 25/2
    }
    
    let count = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.serverImg.image = nil
        self.textView.text = nil
        self.textView.isHidden = true
        self.selectedView.isHidden = true
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            serverImg, selectedView
        ].forEach {self.contentView.addSubview($0)}
        
        serverImg.addSubview(textView)
        serverImg.addSubview(alertBadge)
        
        alertBadge.addSubview(count)
    }
    
    override func bindConstraints() {
        serverImg.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        selectedView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(5)
        }
        
        textView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.edges.equalToSuperview()
        }
        
        alertBadge.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview().offset(15)
            $0.width.height.equalTo(25)
        }
        
        count.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        
        if selected {
            // 원형 -> 둥근 사각형으로
            selectedView.isHidden = false
            serverImg.backgroundColor = .blurple
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.serverImg.layer.cornerRadius = 10.0
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        } else {
            selectedView.isHidden = true
            serverImg.backgroundColor = .messageBarDarkGray
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.serverImg.layer.cornerRadius = 30
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        }
    }
    
    func bind(server: Server) {
        if (server.icon != nil) {
            serverImg.setImage(URL(string: server.icon!)!)
            textView.isHidden = true
        } else {
            textView.isHidden = false
            textView.text = "\(server.name)"
        }

        contentView.addSubview(serverImg)
        
        if (server.count != nil) {
            count.text = "\(server.count!)"
            count.isHidden = false
            alertBadge.isHidden = false
            serverImg.bringSubviewToFront(alertBadge)
        } else {
            count.isHidden = true
            alertBadge.isHidden = true
        }
    }
}
