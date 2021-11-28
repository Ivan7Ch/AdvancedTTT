//
//  ViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 22.05.2021.
//

import UIKit

struct Constants {
    static let collectionViewCornerRadius: CGFloat = 10
}

protocol GameViewControllerDelegate {
    
    func removeSelections()
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var redCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    @IBOutlet weak var redHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var roundedViews: [UIView]!
    @IBOutlet var shadowViews: [UIView]!
    
    var viewModel: GameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameViewModel(vc: self)
        
        setupCollectionViews()
        
        for i in roundedViews {
            i.layer.cornerRadius = 12
            i.layer.masksToBounds = true
        }
        
        for i in shadowViews {
            i.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            i.layer.shadowOpacity = 0.4
            i.layer.shadowOffset = CGSize(width: 5, height: 12)
            i.layer.shadowRadius = 20
        }
        
        view.layoutIfNeeded()
        
        let height = (blueCollectionView.bounds.width - 2) / 3
        redHeightConstraint.constant = height
        blueHeightConstraint.constant = height
        
        addBackground()
    }
    
    private func setupCollectionViews() {
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.layer.cornerRadius = Constants.collectionViewCornerRadius
        
        redCollectionView.delegate = self
        redCollectionView.dataSource = self
        redCollectionView.layer.cornerRadius = Constants.collectionViewCornerRadius
        
        blueCollectionView.delegate = self
        blueCollectionView.dataSource = self
        blueCollectionView.layer.cornerRadius = Constants.collectionViewCornerRadius
    }
    
    func reloadViews() {
        mainCollectionView.reloadData()
        redCollectionView.reloadData()
        blueCollectionView.reloadData()
        viewModel.check()
    }
    
    
    func showWinAlert() {
        let alert = UIAlertController(title: "Do you want to play again?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.viewModel.reloadGame()
        }))
        
        self.present(alert, animated: true)
    }
    
    private func getTypeOf(collectionView: UICollectionView) -> BoardType {
        
        switch collectionView {
        case redCollectionView:
            return .red
        case blueCollectionView:
            return .blue
        default:
            return .main
        }
    }
    
}


extension GameViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return 9
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.lab.text = ""
       
        let type = getTypeOf(collectionView: collectionView)
        let item = viewModel.getItemFor(indexPath, in: type)
            
        cell.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.backgroundColor =  item.color
        cell.diceIcon.image = UIImage(named: "\(item.power)")
        return cell
    }
}


extension GameViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = getTypeOf(collectionView: collectionView)
        viewModel.didTapAt(indexPath, for: type)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        if collectionView == mainCollectionView {
            let cellWidth = (collectionViewWidth / 3) - 1
            return CGSize(width: cellWidth, height: cellWidth)
        }
        let cellWidth = (collectionViewWidth - 3) / 3
        return CGSize(width: cellWidth, height: cellWidth / 2)
    }
}
