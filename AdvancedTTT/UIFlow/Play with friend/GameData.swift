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
    
    func isAnyPossibleMoves(for array: [Item]) -> Bool {
        for item in array {
            if mainSource.contains(where: { item.power > $0.power }) {
                return true
            }
        }
        
        return false
    }
    
    func allPossibleMovesFor(side: Side) -> [Move] {
        var moves = [Move]()
        var source = [Item]()
        
        switch side {
        case .blue:
            source = blueSource
        case .red:
            source = redSource
        case .unknown:
            return []
        }
        
        for i in source {
            for j in mainSource {
                if i.power > j.power, let index = mainSource.firstIndex(of: j) {
                    moves.append(Move(item: i, index: index))
                }
            }
        }
        
        return moves.unique()
    }
    
    func minimax(side: Side, depth: Int, maximizingPlayer: Bool) -> Int {
        let possibleMoves = allPossibleMovesFor(side: side)
        
        if depth == 0 || possibleMoves.count == 0 {
            return evaluate()
        }
        
        if maximizingPlayer {
            var bestValue = Int.min
            
            for move in possibleMoves {
                let item = move.item
                let index = move.index
                
                // Apply the move
                let previousItem = mainSource[index]
                mainSource[index] = item
                
                // Recurse
                let value = minimax(side: side.opposite(), depth: depth - 1, maximizingPlayer: false)
                
                // Undo the move
                mainSource[index] = previousItem
                
                bestValue = max(bestValue, value)
            }
            
            return bestValue
        } else {
            var bestValue = Int.max
            
            for move in possibleMoves {
                let item = move.item
                let index = move.index
                
                // Apply the move
                let previousItem = mainSource[index]
                mainSource[index] = item
                
                // Recurse
                let value = minimax(side: side.opposite(), depth: depth - 1, maximizingPlayer: true)
                
                // Undo the move
                mainSource[index] = previousItem
                
                bestValue = min(bestValue, value)
            }
            
            return bestValue
        }
    }

    private func evaluate() -> Int {
        // Evaluate the current state of the game and return a score
        // This is a simple evaluation function that returns the difference between the number of red tiles and blue tiles
        let redCount = mainSource.filter({ $0.side == .red }).count
        let blueCount = mainSource.filter({ $0.side == .blue }).count
        return redCount - blueCount
    }
    
}
