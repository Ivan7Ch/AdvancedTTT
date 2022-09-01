//
//  FieldIndex.swift
//  AdvancedTTT
//
//  Created by User on 19.06.2022.
//

import Foundation

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
