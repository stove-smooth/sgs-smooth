//
//  MediaCachingService.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/13.
//

import Foundation
import Kingfisher

typealias ProgressBlock = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)
typealias ImageDownloadCompleteBlock = ((UIImage?) -> Void)

extension UIImageView {
    
    func makeCircle() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeRoundedRactangle() {
        let radius = 10.0
        self.layer.cornerRadius = radius
        self.contentMode = .scaleAspectFill
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    
    func setCachedImageOrDownload(_ urlString: String) {
        guard urlString.count > 0 else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            image = nil
            return
        }
        setImage(url)
    }
    
    func setImage(_ url: URL) {
        kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }

}
