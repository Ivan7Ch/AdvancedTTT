//
//  PlayWithPCViewModel.swift
//  AdvancedTTT
//
//  Created by User on 06.02.2022.
//

import Foundation

class PlayWithPCViewModel: GameViewModelBase {
    
    override init(vc: GameViewModelDelegate) {
        super.init(vc: (vc as GameViewModelDelegate))
        self.isBlueMove = true
    }
    
    override func didTapAt(_ indexPath: IndexPath, for type: BoardType) {
        switch type {
        case .main:
            didTapOnMainSource(at: indexPath)
            
            let move = GameBot(field: matrix, mySource: gameData.redSource, opponentSource: gameData.blueSource).makeMove()
            selected = move.item
            didTapOnMainSource(at: move.location.matrixIndex)
        case .red:
            if isBlueMove { break }
            didTapOnSecondary(source: gameData.redSource, at: indexPath)
        case .blue:
            if !isBlueMove { break }
            didTapOnSecondary(source: gameData.blueSource, at: indexPath)
        }
        
        delegate?.reloadViews()
    }
}

struct Move {
    var item: Item
    var location: FieldIndex
}


class FieldIndex {
    let rowIndex: Int
    let matrixIndex: IndexPath
    
    init(rowIndex: Int) {
        self.rowIndex = rowIndex
        
        let row = Int(rowIndex / 3)
        let section = rowIndex % 3
        
        self.matrixIndex = IndexPath(row: row, section: section)
    }
    
    init(matrixIndex: IndexPath) {
        self.matrixIndex = matrixIndex
        self.rowIndex = (matrixIndex.section * 3) + matrixIndex.row
    }
}


class GameBot {
    
    private var field: [[Item]]
    private var mySource: [Item]
    private var opponentSource: [Item]
    private var side: Side
    
    init(field: [[Item]], pcSide: Side = .red, mySource: [Item], opponentSource: [Item]) {
        self.field = field
        self.side = pcSide
        self.mySource = mySource
        self.opponentSource = opponentSource
    }
    
    func makeMove() -> Move {
        
        for i in 0..<9 {
            for s in mySource {
                let move = Move(item: s, location: FieldIndex(rowIndex: i))
                if checkIfValidMove(move: move) {
                    return move
                }
            }
        }
        
        let randomSource = mySource.randomElement()!
        let randomLocation = FieldIndex.init(rowIndex: Int.random(in: 0...8))
        
        let randomMove = Move(item: randomSource, location: randomLocation)
        
        return randomMove
    }
    
    
    //TODO: - remove
    private func flatArray(array: [[Item]]) -> [Item] {
        
        var result = [Item]()
        
        for i in array {
            result.append(contentsOf: i)
        }
        
        return result
    }
    
    private func checkIfValidMove(move: Move) -> Bool {
        let index = move.location.matrixIndex
        return move.item.power > field[index.row][index.section].power
    }
}
