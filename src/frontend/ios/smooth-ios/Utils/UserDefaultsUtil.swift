//
//  UserDefaultsUtil.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation

struct UserDefaultsUtil {
    static let KEY_TOKEN = "KEY_TOKEN"
    static let KEY_CHAT_URL = "KEY_CHAT_URL"
    static let KEY_USER_INFO = "KEY_USER_INFO"
    
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
    
    func setUserInfo(user: User) {
        let propertyListEncoder = try? PropertyListEncoder().encode(user)
        self.instance.set(propertyListEncoder, forKey: UserDefaultsUtil.KEY_USER_INFO)
        
        self.instance.synchronize()
    }
    
    func getUserInfo() -> User? {
        if (self.instance.object(forKey: UserDefaultsUtil.KEY_USER_INFO) != nil) {
            if let data = self.instance.value(forKey: UserDefaultsUtil.KEY_USER_INFO) as? Data {
                let decode = try? PropertyListDecoder().decode(User.self, from: data)
                
                return decode
            }
        }
        return nil
    }
    
    func getChatURL() -> String {
        return self.instance.string(forKey: UserDefaultsUtil.KEY_CHAT_URL) ?? ""
    }
    
    func setChatURL(url: String) {
        self.instance.set(url, forKey: UserDefaultsUtil.KEY_CHAT_URL)
    }

    func clear() {
        self.instance.removeObject(forKey: UserDefaultsUtil.KEY_USER_INFO)
        self.instance.removeObject(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    // MARK: - 구조체 정적 메소드
    static func setUserToken(token: String?) {
        UserDefaults.standard.set(token, forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_TOKEN)
    }
    
    static func setUserInfo(user: User) {
        let propertyListEncoder = try? PropertyListEncoder().encode(user)
        UserDefaults.standard.set(propertyListEncoder, forKey: UserDefaultsUtil.KEY_USER_INFO)
        
        UserDefaults.standard.synchronize()
    }
    
    static func getUserInfo() -> User? {
        return UserDefaults.standard.object(forKey: UserDefaultsUtil.KEY_USER_INFO) as? User
    }
    
    static func setChatURL(url: String?) {
        UserDefaults.standard.set(url, forKey: UserDefaultsUtil.KEY_CHAT_URL)
    }
    
    static func getChatURL() -> String? {
        return UserDefaults.standard.string(forKey: UserDefaultsUtil.KEY_CHAT_URL)
    }
    
    static func clear() {
        setUserToken(token: nil)
    }
}
