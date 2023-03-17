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

class PlayWithPCViewModel: GameViewModelBase {

    var playerBoardType: BoardType
    var room = "000000"
    var bluePlayerId: String = ""
    var redPlayerId: String = ""
    
    init(vc: OnlineGameViewModelDelegate) {
        self.playerBoardType = Bool.random() ? .blue : .red
        super.init(vc: (vc as GameViewModelDelegate))
        self.isBlueMove = vc.playerBoardType == .blue
    }
    
    private func getAvailableItems() {
        
    }
    
    func fetchField() {
        FirebaseHelper(room: room).listenField { [weak self] data in
            
            self?.isBlueMove = data?.isBlueMove ?? false
            self?.setupGameData(data: data)
            self?.delegate?.reloadViews()
            
            if let bluePlayerId = data?.bluePlayer, !bluePlayerId.isEmpty {
                self?.bluePlayerId = bluePlayerId
            } else {
                self?.bluePlayerId = LocalStorageHelper.uniquePlayerID
            }
            
            if let redPlayerId = data?.redPlayer, !redPlayerId.isEmpty {
                self?.redPlayerId = redPlayerId
            } else {
                //need to write on firebase the id
                self?.redPlayerId = LocalStorageHelper.uniquePlayerID
            }
            
            if data?.bluePlayer == LocalStorageHelper.uniquePlayerID {
                self?.playerBoardType = .blue
            } else {
                self?.playerBoardType = .red
            }
        }
    }
    
    override func reloadGame() {
        FirebaseHelper(room: room).writeData(data: RawGameData(field: "aaaaaaaaa", isBlueMove: true, roomNumber: room, bluePlayer: LocalStorageHelper.uniquePlayerID, redPlayer: redPlayerId, blueItems: GameFieldCoder.allBlueItems, redItems: GameFieldCoder.allRedItems))
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
           encodedField.count == 9, type == .main {
            var blueItems: String? = nil
            var redItems: String? = nil
            
            if !isBlueMove {
                blueItems = gameData.blueSource.toStringFiltered()
            } else {
                redItems = gameData.redSource.toStringFiltered()
            }
            
            FirebaseHelper(room: room)
                .updateData(data: RawGameData(field: encodedField,
                                    isBlueMove: isBlueMove,
                                    roomNumber: room,
                                    bluePlayer: bluePlayerId,
                                    redPlayer: redPlayerId,
                                    blueItems: blueItems,
                                    redItems: redItems))
            
        }
        
        delegate?.reloadViews()
    }
    
    private func setupGameData(data: RawGameData?) {
        guard let field = GameFieldCoder.decode(from: data?.field ?? "") else { return }
        
        gameData.mainSource = field
        gameData.blueSource = GameFieldCoder.decode(from: data?.blueItems ?? GameFieldCoder.allBlueItems)!
        gameData.redSource = GameFieldCoder.decode(from: data?.redItems ?? GameFieldCoder.allRedItems)!
    }
}
