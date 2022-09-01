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
            didTapOnMainSource(at: indexPath.row)
            
            let move = GameBot(field: matrix, mySource: gameData.redSource, opponentSource: gameData.blueSource).makeMove()
            selected = move.item
            didTapOnMainSource(at: move.location.rowIndex)
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
