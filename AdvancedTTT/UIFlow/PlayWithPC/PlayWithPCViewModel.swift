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
    
    override func didTapAt(_ indexPath: IndexPath, for type: BoardType) {
        switch type {
        case .main:
            didTapOnMainSource(at: indexPath)
            if !isBlueMove {
                delegate?.reloadViews()
                check()
                if !isFinishedGame {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.makeMove()
                    })
                }
            }
            return
        case .red:
            if isBlueMove { break }
            didTapOnSecondary(source: gameData.redSource, at: indexPath)
        case .blue:
            if !isBlueMove { break }
            didTapOnSecondary(source: gameData.blueSource, at: indexPath)
        }
        
        delegate?.reloadViews()
        check()
    }
    
    override func reloadGame() {
        super.reloadGame()
        isBlueMove = true
    }
    
    private func makeMove() {
        let start = CFAbsoluteTimeGetCurrent()

        
        // Choose the current player
        let currentPlayer: Side = .red

        // Generate a list of all possible moves for the current player
        let possibleMoves = gameData.allPossibleMovesFor(side: currentPlayer)

        // Choose the depth of the search
        let searchDepth = 4

        // Iterate over each move and call minimax on it
        var moveScores = [Int]()
        for move in possibleMoves {
            let item = move.item
            let index = move.index
            
            // Apply the move
            let previousItem = gameData.mainSource[index]
            gameData.mainSource[index] = item
            
            // Call minimax on the new game state
            let score = gameData.minimax(side: currentPlayer.opposite(), depth: searchDepth - 1, maximizingPlayer: true)
            moveScores.append(score)
            
            // Undo the move
            gameData.mainSource[index] = previousItem
        }

        // Find the best move
        var bestMoveIndex = 0
        if currentPlayer == .red {
            var bestScore = Int.min
            for i in 0..<moveScores.count {
                if moveScores[i] > bestScore {
                    bestScore = moveScores[i]
                    bestMoveIndex = i
                }
            }
        } else {
            var bestScore = Int.max
            for i in 0..<moveScores.count {
                if moveScores[i] < bestScore {
                    bestScore = moveScores[i]
                    bestMoveIndex = i
                }
            }
        }

        print("± Took \(CFAbsoluteTimeGetCurrent() - start) seconds")
        // Apply the best move
        let bestMove = possibleMoves[bestMoveIndex]
        didTapAt(IndexPath(row: bestMove.item.power - 1, section: 0), for: .red)
        didTapAt(IndexPath(row: bestMove.index, section: 0), for: .main)
    }
}


struct Move: Hashable {
    let item: Item
    let index: Int
}
