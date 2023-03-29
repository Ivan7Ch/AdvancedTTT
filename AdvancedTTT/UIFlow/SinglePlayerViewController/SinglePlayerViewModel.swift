//
//  SinglePlayerViewModel.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 17.03.2023.
//

import Foundation

class SinglePlayerViewModel: GameViewModelBase {

    var playerBoardType: BoardType
    
    init(vc: OnlineGameViewModelDelegate) {
        self.playerBoardType = Bool.random() ? .blue : .red
        super.init(vc: (vc as GameViewModelDelegate))
        self.isBlueMove = vc.playerBoardType == .blue
    }
    
    override func didTapAt(_ indexPath: IndexPath, for type: BoardType) {
        switch type {
        case .main:
            didTapOnMainSource(at: indexPath)
        case .red:
            if isBlueMove { break }
            didTapOnSecondary(source: gameData.redSource, at: indexPath)
        case .blue:
            if !isBlueMove { break }
            didTapOnSecondary(source: gameData.blueSource, at: indexPath)
        }
        
        delegate?.reloadViews()
    }
    
    func setupGameData(data: RawGameData?) {
        guard let field = GameFieldCoder.decode(from: data?.field ?? "") else { return }
        
        gameData.mainSource = field
        gameData.blueSource = GameFieldCoder.decode(from: data?.blueItems ?? GameFieldCoder.allBlueItems)!
        gameData.redSource = GameFieldCoder.decode(from: data?.redItems ?? GameFieldCoder.allRedItems)!
    }
}
