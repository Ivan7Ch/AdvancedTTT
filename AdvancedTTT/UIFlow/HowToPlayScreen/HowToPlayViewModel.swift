//
//  HowToPlayViewModel.swift
//  AdvancedTTT
//
//  Created by User on 04.01.2022.
//

import Foundation

enum SupportedLanguage: Int {
    case ua
    case lgbt
}

class HowToPlayViewModel {
    
    func getText(for lang: SupportedLanguage) -> String {
        NSLocalizedString("\(lang.rawValue)", comment: "How to play!")
    }
    
}
