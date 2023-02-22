//
//  LanguageHelper.swift
//  AdvancedTTT
//
//  Created by User on 04.02.2022.
//

import Foundation

enum SupportedLanguage: Int, CaseIterable {
    case english
    case spanish
    case french
    case arabic
    case bengali
    case russian
    case portuguese
    case turkish
    case polish
    case ukrainian
    
    var name: String {
        switch self {
        case .english:
            return "English"
        case .spanish:
            return "Spanish"
        case .french:
            return "French"
        case .arabic:
            return "Arabic"
        case .bengali:
            return "Bengali"
        case .russian:
            return "Russian"
        case .portuguese:
            return "Portuguese"
        case .turkish:
            return "Turkish"
        case .polish:
            return "Polish"
        case .ukrainian:
            return "Ukrainian"
        }
    }
}

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self + "\(LocalStorageHelper.currentLanguage.rawValue)", comment: "#trans")
    }
}
