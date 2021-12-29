//
//  UserDefaultsUtil.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct UserDefaultsUtil {
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_USER_ID = "KEY_USER_ID"
    static let KEY_EVENT = "KEY_EVENT"
    
    let instance: UserDefaults
    
    init(name: String? = nil) {
        if let name = name {
            UserDefaults().removePersistentDomain(forName: name)
            
            instance = UserDefaults(suiteName: name)!
        } else {
            instance = UserDefaults.standard
        }
    }
    
    func getUserToken() -> String {
        return self.instance.string(forKey: UserDefaultsUtil.KEY_TOKEN) ?? ""
    }
    
    func setUserToken(token: String) {
        self.instance.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    func clear() {
      self.instance.removeObject(forKey: UserDefaultsUtil.KEY_USER_ID)
      self.instance.removeObject(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func setUserToken(token: String?) {
        
      UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func getUserToken() -> String? {
      return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func clear() {
        setUserToken(token: nil)
    }
}
