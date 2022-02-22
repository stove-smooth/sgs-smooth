//
//  RegexUtils.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/11.
//

import Foundation

class RegExUitils {
    func email(email: String) -> Bool {
        /**
         이메일 아이디 : 대소문자, 숫자, 특수문자 허용
         */
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let checkRegEx = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return checkRegEx.evaluate(with: email)
    }


    func password(password: String) -> Bool {
        /** 8자리 ~ 30자리 영어+숫자+특수문자 */
        let regEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}"
        let checkRegEx = NSPredicate(format: "SELF MATCHES %@", regEx)
        
        return checkRegEx.evaluate(with: password)
    }
}
