//
//  GameBot.swift
//  AdvancedTTT
//
//  Created by User on 19.06.2022.
//

import Foundation

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
        if flatArray(array: field).filter({ $0.side == side }).count >= 2, let move = step1() {
            return move
        }
        
        
//        buildFields()
        
//        for i in 0..<9 {
//            for s in mySource {
//                let move = Move(item: s, location: FieldIndex(rowIndex: i))
//                if checkIfValidMove(move: move) {
//                    return move
//                }
//            }
//        }
        
        var randomMove: Move? = nil
        while true {
            let randomSource = mySource.randomElement()!
            if randomSource.isRemoved { continue }
            randomSource.isRemoved = true
            let rowIndex = Int.random(in: 0...8)
            print("rowIndex - \(rowIndex)")
            let randomLocation = FieldIndex.init(rowIndex: rowIndex)
            randomMove = Move(item: randomSource, location: randomLocation)
            if !checkIfValidMove(move: randomMove!) { continue }
            break
        }
        
        return randomMove!
    }
    
    /// Initial checking. Будуємо всі поля із тайликами найвищого номіналу.
    /// Наприклад найсильніший тайлик в нашому сорсі є тайлик із цифрою 5. Беремо цифру 5 і шукаємо виграшну позицію (максимум 9 перевірок)
    private func step1() -> Move? {
        guard let highestItem = mySource.highestNotRemovedItem() else { return nil }
        
        for i in 0..<3 {
            for j in 0..<3 {
                var copyField = field
                copyField[i][j] = highestItem
                let location = FieldIndex(matrixIndex: IndexPath(row: j, section: i))
                let move = Move(item: highestItem, location: location)
                if checkIfValidMove(move: move) {
                    printField(field: copyField)
                    if validateField(matrix: copyField) == side {
                        return move
                    }
                }
            }
        }
        
        return nil
    }
    
    
//    var fieldsCount = 0
//    private func buildFields(level: Int = 3) {
//        for i in 0..<3 {
//            for j in 0..<3 {
//                for source in mySource {
//                    var copyField = field
//                    guard mySource.count > 0, fieldsCount < 100 else { continue }
//                    copyField[i][j] = source
//
//                    if checkIfValidMove(move: Move(item: source, location: FieldIndex(matrixIndex: IndexPath(row: i, section: j)))) {
//                        printField(field: copyField)
//                        fieldsCount += 1
//    //                    buildFields()
//                    }
//                }
//            }
//        }
//        print("=============")
//    }
    
    private func printField(field: [[Item]]) {
        for row in field {
            print(row.map({ "\($0.debugDescription)" }).joined(separator: " "))
        }
        print("---------")
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
    
    private func checkIfValidMove(move: Move, field: [[Item]]) -> Bool {
        let index = move.location.matrixIndex
        return move.item.power > field[index.row][index.section].power
    }
}



