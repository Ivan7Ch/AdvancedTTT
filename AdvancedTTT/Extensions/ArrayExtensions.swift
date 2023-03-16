//
//  ArrayExtensions.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 15.03.2023.
//

import Foundation

extension Array where Element : Item {

    func toString() -> String? {
        GameFieldCoder.encode(from: self)
    }
    
    func toStringFiltered() -> String? {
        GameFieldCoder.encode(from: self)//?.filter({ $0 != "a"})
    }
}
