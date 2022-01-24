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

class ServerCell: UITableViewCell {
    static let identifier = "ServerCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.serverImg.image = nil
        self.textView.text = nil
        self.textView.isHidden = true
        self.selectedView.isHidden = true
    }
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            serverImg, selectedView
        ].forEach {self.contentView.addSubview($0)}
        
        serverImg.addSubview(textView)
        
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
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
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
            if (server.name.count > 5) {
                let subIdx: String.Index = server.name.index(server.name.startIndex, offsetBy: 2)
                let result = "\(server.name[...subIdx])"+"..."
                
                textView.text = result
            } else {
                textView.text = "\(server.name)"
            }
            
        }

        contentView.addSubview(serverImg)
    }
}
