//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit

class HomeViewController: BaseBackgroundViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.forEach({ $0.layer.cornerRadius = Constants.generalCornerRadius })
    }
}
