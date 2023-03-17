//
//  PlayOnlineViewController.swift
//  AdvancedTTT
//
//  Created by User on 08.01.2022.
//

import UIKit
import GoogleMobileAds


class PlayOnlineViewController: SinglePlayerViewController {
    
    var roomNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = roomNumber
        
        viewModel = PlayOnlineViewModel(vc: self)
        viewModel.playerBoardType = playerBoardType
        viewModel.room = roomNumber
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadViews()
        (viewModel!).fetchField()
    }
}
