//
//  FieldValidation.swift
//  AdvancedTTT
//
//  Created by User on 19.06.2022.
//

import Foundation

func validateField(matrix: [[Item]]) -> Side? {
    
    for j in 0..<3 {
        if matrix[j][0].side == .unknown { continue }
        if matrix[j][0].side == matrix[j][1].side, matrix[j][1].side == matrix[j][2].side {
            return matrix[j][0].side
        }
    }
    
    for j in 0..<3 {
        if matrix[0][j].side == .unknown { continue }
        if matrix[0][j].side == matrix[1][j].side, matrix[1][j].side == matrix[2][j].side {
            return matrix[0][j].side
        }
    }
    
    if matrix[0][0].side != .unknown, matrix[0][0].side == matrix[1][1].side, matrix[1][1].side == matrix[2][2].side {
        return matrix[0][0].side
    }
    
    if matrix[0][2].side != .unknown, matrix[0][2].side == matrix[1][1].side, matrix[1][1].side == matrix[2][0].side {
        return matrix[0][2].side
    }
    
    return nil
}
