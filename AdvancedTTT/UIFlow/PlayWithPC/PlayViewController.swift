//
//  PlayViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 17.03.2023.
//

import UIKit

class PlayViewController: SinglePlayerViewController {
    
    
    override func viewDidLoad() {
        playerBoardType = .blue
        
        viewModel = PlayWithPCViewModel(vc: self)
        viewModel.playerBoardType = playerBoardType
        
        super.viewDidLoad()
        
        
    }
}
