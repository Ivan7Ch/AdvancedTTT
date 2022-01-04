//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addBackground()
        
        playButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        howToPlayButton.layer.cornerRadius = Constants.collectionViewCornerRadius
    }
    
}
