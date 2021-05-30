//
//  ViewModel.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 27.05.2021.
//

import Foundation


class ViewModel {
    
    let vc: ViewController
    
    private var matrixDoble = Array(repeating: Array(repeating: Item(power: 0, side: .unknown), count: 3), count: 3)
    
    init(vc: ViewController) {
        self.vc = vc
        
        initDoubleMatrix()
    }
    
    private func initDoubleMatrix() {
        
        let doubleMatrixLength: Int = Int(sqrt(Double(vc.mainSource.count)))
        
        for i in 0..<doubleMatrixLength {
            for j in 0..<doubleMatrixLength {
                matrixDoble[i][j].power = vc.mainSource[i * doubleMatrixLength + j].power
                matrixDoble[i][j].side = vc.mainSource[i * doubleMatrixLength + j].side
            }
        }
    }
    
    func check() {
        initDoubleMatrix()
        
        for j in 0..<3 {
            if matrixDoble[j][0].side == .unknown { continue }
            if matrixDoble[j][0].side == matrixDoble[j][1].side, matrixDoble[j][1].side == matrixDoble[j][2].side {
                vc.showWinAlert()
                return
            }
        }
        
        for j in 0..<3 {
            if matrixDoble[0][j].side == .unknown { continue }
            if matrixDoble[0][j].side == matrixDoble[1][j].side, matrixDoble[1][j].side == matrixDoble[2][j].side {
                vc.showWinAlert()
                return
            }
        }
        
        if matrixDoble[0][0].side != .unknown, matrixDoble[0][0].side == matrixDoble[1][1].side, matrixDoble[1][1].side == matrixDoble[2][2].side {
            vc.showWinAlert()
            return
        }
        
        if matrixDoble[0][2].side != .unknown, matrixDoble[0][2].side == matrixDoble[1][1].side, matrixDoble[1][1].side == matrixDoble[2][0].side {
            vc.showWinAlert()
            return
        }
    }
    
    func isAllowedMoveForBlue() -> Bool {
        
        
        return true
    }
    
}
