//
//  HowToPlayViewController.swift
//  AdvancedTTT
//
//  Created by User on 04.01.2022.
//

import UIKit

class HowToPlayViewController: BaseBackgroundViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: HowToPlayViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HowToPlayViewModel()
        
        textView.text = viewModel.getText(for: .ukrainian)
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didLanguageTap(_ button: UIButton) {
        let lang = SupportedLanguage(rawValue: button.tag) ?? .ukrainian
        textView.text = viewModel.getText(for: lang)
    }
}
