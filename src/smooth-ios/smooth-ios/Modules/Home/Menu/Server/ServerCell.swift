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
    static var identifier: String { return "\(self)" }
    
    let img: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 15, y: 0, width: 60, height: 60))
        imgView.image = UIImage(systemName: "star.fill")
        imgView.makeCircle()
        
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // 원형 -> 둥근 사각형으로
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.img.layer.cornerRadius = 10.0
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.img.layer.cornerRadius = 30
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        }
    }
    
    func ui(data: String) {
        self.backgroundColor = .clear
        self.separatorInset = UIEdgeInsets.all(3)
        self.selectionStyle = .none
        
        // TODO: 
        guard let imageUrl = URL(string: "https://cdn.cashfeed.co.kr/attachments/c4845cdd2b.jpg") else {
            img.image = UIImage()
            return }
        img.setImage(imageUrl)
        
        contentView.addSubview(img)
    }
}
