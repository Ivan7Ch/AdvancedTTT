//
//  ViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 22.05.2021.
//

import UIKit
import GoogleMobileAds

struct Constants {
    static let generalCornerRadius: CGFloat = 10
}

protocol GameViewControllerDelegate {
    
    func removeSelections()
}

class GameViewController: BaseBackgroundViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var redCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    @IBOutlet weak var redHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var roundedViews: [UIView]!
    @IBOutlet var shadowViews: [UIView]!
    
    var viewModel: GameViewModelBase!
    var interstitial: GADInterstitialAd?
    var defaultHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameViewModelBase(vc: self)
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadAdvertIfNeeded(isNeed: false)
    }
    
    private func setupCornerRadius() {
        
        for i in roundedViews {
            i.layer.cornerRadius = 12
            i.layer.masksToBounds = true
        }
    }
    
    private func setupShadows() {
        
        for i in shadowViews {
            i.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            i.layer.shadowOpacity = 0.4
            i.layer.shadowOffset = CGSize(width: 5, height: 12)
            i.layer.shadowRadius = 20
        }
    }
    
    private func setupCollectionViews() {
        
        //main
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.layer.cornerRadius = Constants.generalCornerRadius
        
        //red
        redCollectionView.delegate = self
        redCollectionView.dataSource = self
        redCollectionView.layer.cornerRadius = Constants.generalCornerRadius
//        redCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        //blue
        blueCollectionView.delegate = self
        blueCollectionView.dataSource = self
        blueCollectionView.layer.cornerRadius = Constants.generalCornerRadius
//        blueCollectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
        setCollectionViewDisabled(.red)
    }
    
    private func setupDrag() {
        
        mainCollectionView.dragInteractionEnabled = true
        mainCollectionView.dragDelegate = self
        mainCollectionView.dropDelegate = self
        
        redCollectionView.dragInteractionEnabled = true
        redCollectionView.dragDelegate = self
        redCollectionView.dropDelegate = self
        
        blueCollectionView.dragInteractionEnabled = true
        blueCollectionView.dragDelegate = self
        blueCollectionView.dropDelegate = self
        
        changeMinimumPressDuration(for: blueCollectionView, 0.1)
        changeMinimumPressDuration(for: redCollectionView, 0.1)
    }
    
    private func setupViews() {
        setupCollectionViews()
        setupCornerRadius()
        setupShadows()
    }
    
    private func changeMinimumPressDuration(for collectionView: UICollectionView, _ duration: TimeInterval) {
        
        collectionView.gestureRecognizers?.forEach { (recognizer) in
            if let longPressRecognizer = recognizer as? UILongPressGestureRecognizer {
                longPressRecognizer.minimumPressDuration = duration
            }
        }
    }
    
    private func setCollectionViewDisabled(_ collectionView: UICollectionView, isDisabled: Bool) {
        collectionView.isUserInteractionEnabled = !isDisabled
        UIView.animate(withDuration: 0.15, animations: {
            collectionView.alpha = isDisabled ? 0.3 : 1
        })
    }
    
    func getTypeOf(_ collectionView: UICollectionView) -> BoardType {
        
        switch collectionView {
        case redCollectionView:
            return .red
        case blueCollectionView:
            return .blue
        default:
            return .main
        }
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReloadButton() {
        viewModel.reloadGame()
    }
}


//MARK: - GameViewModelDelegate
extension GameViewController: GameViewModelDelegate {
    
    func showWinAlert(with title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { [weak self] _ in
            guard let self = self, let interstitial = self.interstitial else {
                self?.viewModel.reloadGame()
                return
            }
            
            interstitial.present(fromRootViewController: self)
        }))
        
        self.present(alert, animated: true)
    }
    
    func reloadViews() {
        mainCollectionView.reloadData()
        redCollectionView.reloadData()
        blueCollectionView.reloadData()
        viewModel.check()
    }
    
    func setCollectionViewDisabled(_ boardType: BoardType) {
        setCollectionViewDisabled(redCollectionView, isDisabled: boardType == .red)
        setCollectionViewDisabled(blueCollectionView, isDisabled: boardType == .blue)
    }
}
