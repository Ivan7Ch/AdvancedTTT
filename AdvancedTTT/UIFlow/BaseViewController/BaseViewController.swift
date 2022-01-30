//
//  BaseViewController.swift
//  AdvancedTTT
//
//  Created by User on 30.01.2022.
//

import UIKit
import Pastel

class BaseBackgroundViewController: UIViewController {
    
    var pastelView: PastelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastelView = pastelView()
        view.insertSubview(pastelView, at: 0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        pastelView.removeFromSuperview()
        pastelView = pastelView()
        view.insertSubview(pastelView, at: 0)
    }
}
