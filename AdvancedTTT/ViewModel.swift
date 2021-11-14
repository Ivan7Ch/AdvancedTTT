//
//  ViewModel.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 27.05.2021.
//

import Foundation


class ViewModel {
    
    let vc: GameViewController
    
    private var matrix = [[Item]]()
    private let sideLenght = 3
    
    
    init(vc: GameViewController) {
        self.vc = vc
    }
    
    private func setupMatrix() {
        matrix = [[Item]]()
        for i in 0..<sideLenght {
            var arr = [Item]()
            for j in 0..<sideLenght {
                let item = vc.mainSource[i * sideLenght + j]
                arr.append(item)
            }
            matrix.append(arr)
        }
    }
    
    func check() {
        setupMatrix()
        if vc.redSource.filter({ $0.side == .unknown }).count == 6 || vc.blueSource.filter({ $0.side == .unknown }).count == 6 {
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
