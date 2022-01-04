//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    
    private var interstitial: GADInterstitialAd?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        howToPlayButton.layer.cornerRadius = Constants.collectionViewCornerRadius
        
        
    }
}
