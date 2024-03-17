//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playWithPCButton: UIButton!
    @IBOutlet weak var playOnlineButton: UIButton!
    @IBOutlet weak var playWithFriendButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playWithPCButton.layer.cornerRadius = Constants.generalCornerRadius
        playOnlineButton.layer.cornerRadius = Constants.generalCornerRadius
        playWithFriendButton.layer.cornerRadius = Constants.generalCornerRadius
        howToPlayButton.layer.cornerRadius = Constants.generalCornerRadius
        aboutButton.layer.cornerRadius = Constants.generalCornerRadius
        
        ContentProvider.updateLogo(completion: { urlString in
            if let urlString = urlString, let imageUrl = URL(string: urlString) {
                self.logoImageView.kf.setImage(with: imageUrl)
            }
        })
        
    }
}
