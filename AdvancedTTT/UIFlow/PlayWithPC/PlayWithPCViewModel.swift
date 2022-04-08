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
            
            let move = GameBot.makeMove(field: matrix)
            selected = move.0
            didTapOnMainSource(at: move.1)
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

class GameBot {
    
    static var ind = -1
    
    static func makeMove(field: [[Item]]) -> (Item, IndexPath) {
        
        let items = [Item(power: 5, side: .red),
                     Item(power: 6, side: .red),
                     Item(power: 4, side: .red)]
        
        let index = [IndexPath(row: 4, section: 0),
                     IndexPath(row: 2, section: 0),
                     IndexPath(row: 6, section: 0)]
        
        ind += 1
        
        return (items[ind], index[ind])
    }
}
