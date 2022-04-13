//
//  HomeViewController.swift
//  AdvancedTTT
//
//  Created by User on 24.12.2021.
//

import UIKit

class HomeViewController: BaseBackgroundViewController {
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttons.forEach({ $0.layer.cornerRadius = Constants.generalCornerRadius })
        
        if Constants.isSimpleVersion {
            buttons[1].isHidden = true
            buttons[3].isHidden = true
            buttons[4].isHidden = true
            stackViewHeightConstraint.constant = 129
            
            buttons[0].setTitle("Правила гри", for: .normal)
            buttons[2].setTitle("Грати", for: .normal)
        }
    }
}
