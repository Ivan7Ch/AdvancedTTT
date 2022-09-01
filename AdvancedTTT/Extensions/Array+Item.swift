//
//  Array+Item.swift
//  AdvancedTTT
//
//  Created by User on 19.06.2022.
//

import Foundation

extension Array where Element : Item {
    
    func highestItem() -> Item? {
        return self.sorted(by: { $0.power > $1.power }).first
    }
    
    func highestNotRemovedItem() -> Item? {
        self.filter({ !$0.isRemoved }).highestItem()
    }
}
