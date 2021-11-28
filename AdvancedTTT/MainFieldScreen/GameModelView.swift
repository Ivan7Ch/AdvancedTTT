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
    
    var blueMove = true
    var selected: Item?
    
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
    
    func reloadGame() {
        gameData.setupArrays()
        vc.reloadViews()
    }
    
    func didTapAt(_ indexPath: IndexPath, for type: BoardType) {
        switch type {
        case .main:
            didTapOnMainSource(at: indexPath)
        case .red:
            if blueMove { break }
            didTapOnSecondary(source: gameData.redSource, at: indexPath)
        case .blue:
            if !blueMove { break }
            didTapOnSecondary(source: gameData.blueSource, at: indexPath)
        }
        
        vc.reloadViews()
    }
    
    private func didTapOnMainSource(at indexPath: IndexPath) {
        guard let selected = selected else { return }
        if selected.power == 0 { return }
        if selected.power <= gameData.mainSource[indexPath.row].power { return }
        gameData.mainSource[indexPath.row].power = selected.power
        gameData.mainSource[indexPath.row].side = selected.side
        self.selected = nil
        removeSelections()
        blueMove.toggle()
    }
    
    private func didTapOnSecondary(source: [Item], at indexPath: IndexPath) {
        gameData.deselectAll()
        if selected == source[indexPath.row] {
            selected = nil
        } else if selected != source[indexPath.row] {
            selected = source[indexPath.row]
            selected!.isSelected = true
        }
    }
}
