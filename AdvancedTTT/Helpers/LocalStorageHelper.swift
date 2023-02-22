//
//  LocalStorageHelper.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 22.02.2023.
//

import Foundation

class LocalStorageHelper {
    
    static var currentLanguage: SupportedLanguage {
        let langCode = UserDefaults.standard.integer(forKey: "lang")
        let lang = SupportedLanguage(rawValue: langCode) ?? .english
        
        return lang
    }
    
    static func setLanguage(language: SupportedLanguage) {
        UserDefaults.standard.set(language.rawValue, forKey: "lang")
    }
    
    static var uniquePlayerID: String {
        guard
            let id = UserDefaults.standard.string(forKey: "uuid")
        else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "uuid")
            return uuid
        }
        
        return id
    }
}
