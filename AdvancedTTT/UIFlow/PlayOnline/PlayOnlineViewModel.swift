//
//  PlayOnlineViewModel.swift
//  AdvancedTTT
//
//  Created by User on 08.01.2022.
//

import Foundation

protocol OnlineGameViewModelDelegate: GameViewModelDelegate {
    var playerBoardType: BoardType! { get set }
}

class PlayOnlineViewModel: GameViewModelBase {

    var playerBoardType: BoardType
    var room = "000000"
    
    init(vc: OnlineGameViewModelDelegate) {
        self.playerBoardType = Bool.random() ? .blue : .red
        super.init(vc: (vc as GameViewModelDelegate))
        self.isBlueMove = vc.playerBoardType == .blue
    }
    
    func fetchField() {
        FirebaseHelper(room: room).listenField { [weak self] data in
            guard let field = GameFieldCoder.decode(from: data?.field ?? "") else { return }
            
            self?.isBlueMove = data?.isBlueMove ?? false
            self?.gameData.mainSource = field
            self?.delegate?.reloadViews()
        }
    }
    
    override func reloadGame() {
        FirebaseHelper(room: room).writeData(data: RawGameData(field: "aaaaaaaaa", isBlueMove: true, roomNumber: room))
        gameData.setupArrays()
        delegate?.reloadViews()
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
        
        if let encodedField = GameFieldCoder.encode(from: gameData.mainSource),
           encodedField.count == 9 {
            FirebaseHelper(room: room).writeData(data: RawGameData(field: encodedField, isBlueMove: isBlueMove, roomNumber: room))
        }
        
        delegate?.reloadViews()
    }
}
