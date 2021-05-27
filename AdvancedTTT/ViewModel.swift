//
//  ViewModel.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 27.05.2021.
//

import Foundation


class ViewModel {
    
    let vc: ViewController
    
    private var matrixDoble = Array(repeating: Array(repeating: Item(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), power: 0), count: 3), count: 3)
    
    init(vc: ViewController) {
        self.vc = vc
        
        initDoubleMatrix()
    }
    
    private func initDoubleMatrix(){
        
        let doubleMatrixLength: Int = Int(sqrt(Double(vc.mainSource.count)))
        
        for i in 0..<doubleMatrixLength {
            for j in 0..<doubleMatrixLength {
                matrixDoble[j][j].color = vc.mainSource[i * doubleMatrixLength + j].color
                matrixDoble[j][j].power = vc.mainSource[i * doubleMatrixLength + j].power
            }
        }
    }
    
    func check() {
        
        for j: Int in 0..<3 {
            if(matrixDoble[j][0] == matrixDoble[j][1] && matrixDoble[j][1] == matrixDoble[j][2]) {
                print("\(matrixDoble[j][0]) is won!")
                
                vc.showWinAlert()
            }
            
            if(matrixDoble[0][j] == matrixDoble[1][j] && matrixDoble[1][j] == matrixDoble[2][j]) {
                print("\(matrixDoble[0][j]) is won!")
            }
        }
        
        if(matrixDoble[0][0] == matrixDoble[1][1] && matrixDoble[1][1] == matrixDoble[2][2]) {
            print("\(matrixDoble[0][0]) is won!")
        }
        
        if(matrixDoble[0][2] == matrixDoble[1][1] && matrixDoble[1][1] == matrixDoble[2][0]) {
            print("\(matrixDoble[0][2]) is won!")
        }
    }
    
    func isAllowedMoveForBlue() -> Bool {
        
        
        return true
    }
    
}
