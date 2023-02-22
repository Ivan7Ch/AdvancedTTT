//
//  SettingsViewController.swift
//  AdvancedTTT
//
//  Created by User on 04.02.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var languagesButton: UIButton!
    
    var menu = UIMenu()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
    }

    private func setupMenu() {
        var actions = [UIAction]()
        
        let currentLanguge = LocalStorageHelper.currentLanguage
        for i in SupportedLanguage.allCases {
            let imageName = i == currentLanguge ? "checkmark.circle.fill" : "checkmark.circle"
            let action = UIAction(title: i.name, image: UIImage(systemName: imageName), handler: { [weak self] _ in
                LocalStorageHelper.setLanguage(language: i)
                self?.localizeViews()
            })
            actions.append(action)
        }
        
        menu = UIMenu(title: "Languages", children: actions)
        languagesButton.showsMenuAsPrimaryAction = true
        languagesButton.menu = menu
    }
    
    private func localizeViews() {
        title = "Settings".localized()
        languagesButton.setTitle("Choose Language", for: .normal)
        setupMenu()
    }
}
