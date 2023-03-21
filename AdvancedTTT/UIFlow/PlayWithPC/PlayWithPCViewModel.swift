//
//  PlayWithPCViewModel.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 17.03.2023.
//

import Foundation

protocol PlayWithPCViewModelDelegate: GameViewModelDelegate {
    var playerBoardType: BoardType! { get set }
}

class PlayWithPCViewModel: SinglePlayerViewModel {

    override init(vc: OnlineGameViewModelDelegate) {
        super.init(vc: vc)
    }
    
    private func getAvailableItems() {
        
    }
    
    override func didTapAt(_ indexPath: IndexPath, for type: BoardType) {
        switch type {
        case .main:
            didTapOnMainSource(at: indexPath)
            if !isBlueMove {
                makeMove()
            }
        case .red:
            if isBlueMove { break }
            didTapOnSecondary(source: gameData.redSource, at: indexPath)
        case .blue:
            if !isBlueMove { break }
            didTapOnSecondary(source: gameData.blueSource, at: indexPath)
        }
        
        delegate?.reloadViews()
    }
    
    private func makeMove() {
        didTapAt(IndexPath(row: 1, section: 0), for: .red)
        didTapAt(IndexPath(row: 7, section: 0), for: .main)
    }
}
