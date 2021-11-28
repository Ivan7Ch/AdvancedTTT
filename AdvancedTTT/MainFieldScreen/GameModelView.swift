//
//  GameModelView.swift
//  AdvancedTTT
//
//  Created by User on 28.11.2021.
//

import Foundation

class GameViewModel {
    
    let vc: GameViewController
    let gameData: GameData
    
    private var matrix = [[Item]]()
    private let sideLenght = 3
    
    
    init(vc: GameViewController) {
        self.vc = vc
        self.gameData = GameData()
    }
    
    private func setupMatrix() {
        matrix = [[Item]]()
        for i in 0..<sideLenght {
            var arr = [Item]()
            for j in 0..<sideLenght {
                let item = gameData.mainSource[i * sideLenght + j]
                arr.append(item)
            }
            matrix.append(arr)
        }
    }
    
    func check() {
        setupMatrix()
        if gameData.redSource.filter({ $0.side == .unknown }).count == 6 && gameData.blueSource.filter({ $0.side == .unknown }).count == 6 {
            vc.showWinAlert()
            return
        }
        
        for j in 0..<3 {
            if matrix[j][0].side == .unknown { continue }
            if matrix[j][0].side == matrix[j][1].side, matrix[j][1].side == matrix[j][2].side {
                vc.showWinAlert()
                return
            }
        }
        
        for j in 0..<3 {
            if matrix[0][j].side == .unknown { continue }
            if matrix[0][j].side == matrix[1][j].side, matrix[1][j].side == matrix[2][j].side {
                vc.showWinAlert()
                return
            }
        }
        
        if matrix[0][0].side != .unknown, matrix[0][0].side == matrix[1][1].side, matrix[1][1].side == matrix[2][2].side {
            vc.showWinAlert()
            return
        }
        
        if matrix[0][2].side != .unknown, matrix[0][2].side == matrix[1][1].side, matrix[1][1].side == matrix[2][0].side {
            vc.showWinAlert()
            return
        }
    }
}


extension GameViewModel {
    
    func removeSelections() {
        gameData.removeSelections()
        vc.reloadViews()
    }
    
    func getItemFor(_ indexPath: IndexPath, in resourceType: BoardType) -> Item {
        switch resourceType {
        case .main:
            return gameData.mainSource[indexPath.row]
        case .blue:
            return gameData.blueSource[indexPath.row]
        case .red:
            return gameData.redSource[indexPath.row]
        }
    }
}
