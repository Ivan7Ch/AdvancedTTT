//
//  PlayOnlineViewController.swift
//  AdvancedTTT
//
//  Created by User on 08.01.2022.
//

import UIKit
import GoogleMobileAds


class PlayOnlineViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    @IBOutlet weak var blueHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var roundedViews: [UIView]!
    @IBOutlet var shadowViews: [UIView]!
    
    private var viewModel: PlayOnlineViewModel!
    private var interstitial: GADInterstitialAd?
    private var defaultHeight: CGFloat = 0
    
    var playerBoardType: BoardType!
    var roomNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = roomNumber
        addBackground()
        
        viewModel = PlayOnlineViewModel(vc: self)
        viewModel.playerBoardType = playerBoardType
        viewModel.room = roomNumber
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadViews()
        viewModel.fetchField()
    }
    
    private func setupCollectionViews() {
        
        //main
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.layer.cornerRadius = Constants.collectionViewCornerRadius
        
        //blue
        blueCollectionView.delegate = self
        blueCollectionView.dataSource = self
        blueCollectionView.layer.cornerRadius = Constants.collectionViewCornerRadius
    }
    
    func reloadViews() {
        mainCollectionView.reloadData()
        blueCollectionView.reloadData()
        viewModel.check()
    }
    
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
    
    func setCollectionViewDisabled(_ boardType: BoardType) {
//        setCollectionViewDisabled(blueCollectionView, isDisabled: boardType == .blue)
    }
    
    private func setCollectionViewDisabled(_ collectionView: UICollectionView, isDisabled: Bool) {
        collectionView.isUserInteractionEnabled = !isDisabled
        UIView.animate(withDuration: 0.15, animations: {
            collectionView.alpha = isDisabled ? 0.3 : 1
        })
    }
    
    private func getTypeOf(_ collectionView: UICollectionView) -> BoardType {
        
        switch collectionView {
        case mainCollectionView:
            return .main
        default:
            return viewModel.playerBoardType
        }
    }
    
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapReloadButton() {
        viewModel.reloadGame()
    }
}


extension PlayOnlineViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return 9
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.lab.text = ""
       
        let type = getTypeOf(collectionView)
        let item = viewModel.getItemFor(indexPath, in: type)
            
        cell.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.backgroundColor = item.color
        cell.diceIcon.image = UIImage(named: "\(item.power)")
        return cell
    }
}


extension PlayOnlineViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = getTypeOf(collectionView)
        viewModel.didTapAt(indexPath, for: type)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        if collectionView == mainCollectionView {
            let cellWidth = (width / 3) - 1
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        return CGSize(width: (width - 2) / 3, height: (height - 1) / 2)
    }
}


// MARK: - UICollectionViewDragDelegate Methods
extension PlayOnlineViewController : UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if collectionView == mainCollectionView { return [] }
        
        viewModel.didTapToDrag(at: indexPath, for: getTypeOf(collectionView))
        
        let item = ""
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == mainCollectionView { return nil }
        
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 118, height: 56))
        return previewParameters
    }
}

// MARK: - UICollectionViewDropDelegate Methods
extension PlayOnlineViewController : UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        if let indexPath = destinationIndexPath,
           viewModel.canDropItem(at: indexPath, on: getTypeOf(collectionView)) {
            return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            viewModel.didTapAt(destinationIndexPath, for: .main)
        default:
            return
        }
    }
}

extension PlayOnlineViewController: GADFullScreenContentDelegate {
    
    private func loadAdvert() {
        let request = GADRequest()
        //ca-app-pub-9391157593798156/5924690659
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910", request: request, completionHandler: { [self] ad, error in
            
            if let error = error {
                print("§ Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            print("§ success")
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("§ Ad did fail to present full screen content.")
        viewModel.reloadGame()
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("§ Ad did dismiss full screen content.")
        viewModel.reloadGame()
    }
}

