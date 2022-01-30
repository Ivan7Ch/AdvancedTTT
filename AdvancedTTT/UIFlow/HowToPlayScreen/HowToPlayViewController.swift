//
//  HowToPlayViewController.swift
//  AdvancedTTT
//
//  Created by User on 04.01.2022.
//

import UIKit

class HowToPlayViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: HowToPlayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackground()
        
        viewModel = HowToPlayViewModel()
        
        textView.text = viewModel.getText(for: .ua)
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didLanguageTap(_ button: UIButton) {
        let lang = SupportedLanguage(rawValue: button.tag) ?? .ua
        textView.text = viewModel.getText(for: lang)
    }
}
