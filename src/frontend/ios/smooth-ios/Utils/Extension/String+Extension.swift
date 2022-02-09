//
//  String+Extension.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/07.
//

import Foundation
import UIKit

extension String {
    var ISOtoDate: Date {
        let string = self+"Z"
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds,
            .withColonSeparatorInTime,.withDashSeparatorInDate,
            .withTimeZone
        ]
        return dateFormatter.date(from: string)!
    }
    
    func toUIImage() -> UIImage? {
    let url = URL(string: self)
    if let data = try? Data(contentsOf: url!) {
            return UIImage(data: data)
        }
        return nil
    }
}
