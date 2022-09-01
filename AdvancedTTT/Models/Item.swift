//
//  Item.swift
//  AdvancedTTT
//
//  Created by User on 28.11.2021.
//

import UIKit

class Item: NSObject {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.power == rhs.power && lhs.color == rhs.color && lhs.side == rhs.side
    }
    
    var color: UIColor {
        switch side {
        case .blue:
            return isSelected ? #colorLiteral(red: 0.4729953579, green: 0.778148411, blue: 0.9084692468, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .red:
            return isSelected ? #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .unknown:
            return isRemoved ? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var power: Int
    var side: Side
    var isSelected = false
    var isRemoved = false
    
    init(power: Int, side: Side) {
        self.power = power
        self.side = side
    }
    
    override var debugDescription: String {
        switch side {
        case .blue:
            return "\(power)@"
        case .red:
            return "\(power)#"
        case .unknown:
            return "OO"
        }
    }
}
