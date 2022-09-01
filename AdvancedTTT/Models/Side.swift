//
//  Side.swift
//  AdvancedTTT
//
//  Created by User on 28.11.2021.
//

import UIKit

enum Side: String {
    case blue = "@"
    case red = "#"
    case unknown = "_"
    
    var color: UIColor {
        switch self {
        case .blue:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .red:
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
