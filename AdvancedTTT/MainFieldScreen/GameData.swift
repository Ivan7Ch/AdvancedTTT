//
//  GameData.swift
//  AdvancedTTT
//
//  Created by User on 28.11.2021.
//

import Foundation

class GameData {
    
    var mainSource = [Item]()
    var redSource = [Item]()
    var blueSource = [Item]()
    
    init() {
        setupArrays()
    }
    
    func setupArrays() {
        
        mainSource = [Item]()
        redSource = [Item]()
        blueSource = [Item]()
        
        for _ in 0..<9 {
            mainSource.append(Item(power: 0, side: .unknown))
        }
        for i in 1...6 {
            let item1 = Item(power: i, side: .red)
            let item2 = Item(power: i, side: .blue)
            redSource.append(item1)
            blueSource.append(item2)
        }
    }
    
    func removeSelections() {
        for i in blueSource {
            if i.isSelected {
                i.isSelected = false
                i.isRemoved = true
                i.side = .unknown
                i.power = 0
            }
        }
        
        for i in redSource {
            if i.isSelected {
                i.isSelected = false
                i.isRemoved = true
                i.side = .unknown
                i.power = 0
            }
        }
    }
    
    func deselectAll() {
        for i in blueSource {
            if i.isSelected {
                i.isSelected = false
                i.isSelected = false
            }
        }
        
        for i in redSource {
            if i.isSelected {
                i.isSelected = false
            }
        }
    }
}
