//
//  PlayViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 17.03.2023.
//

import UIKit

class PlayViewController: SinglePlayerViewController, PlayWithPCViewModelDelegate {
    
    private var activityIndicator: UIActivityIndicatorView!
    
    func showProgress(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        setCollectionViewDisabled(blueCollectionView, isDisabled: show)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerBoardType = .blue
        
        viewModel = PlayWithPCViewModel(vc: self)
        viewModel.playerBoardType = playerBoardType
        
        setupUI()
    }
    
    private func setupUI() {
        // Create and configure the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the activity indicator to the view
        view.addSubview(activityIndicator)
        
        // Center the activity indicator in the view
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
