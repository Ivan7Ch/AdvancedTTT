//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
//    @IBOutlet weak var playWithPCButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!
    @IBOutlet weak var playWithFriendButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackground()
        
//        playOnlineButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        playWithFriendButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        howToPlayButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        aboutButton.layer.cornerRadius = Constants.collectionViewCornerRadius
    }
}
