//
//  ViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 22.05.2021.
//

import UIKit
import Pastel

enum Side {
    case blue
    case red
    case unknown
}

class Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.power == rhs.power && lhs.color == rhs.color && lhs.side == rhs.side
    }
    
    var color: UIColor {
        switch side {
        case .blue:
            return isSelected ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .red:
            return isSelected ? #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case .unknown:
            return isRemoved ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
    
    var power: Int
    var side: Side
    var isSelected = false
    var isRemoved = false
    
    init(power: Int, side: Side) {
        self.power = power
        self.side = side
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var redCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    @IBOutlet weak var redHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var roundedViews: [UIView]!
    @IBOutlet var shadowViews: [UIView]!
    
    var mainSource = [Item]()
    var redSource = [Item]()
    var blueSource = [Item]()
    
    var selected: Item?
    
    var viewModel: ViewModel!
    var blueMove = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        viewModel = ViewModel(vc: self)
        setupViews()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.layer.cornerRadius = 10
        
        redCollectionView.delegate = self
        redCollectionView.dataSource = self
        redCollectionView.layer.cornerRadius = 10
        
        blueCollectionView.delegate = self
        blueCollectionView.dataSource = self
        blueCollectionView.layer.cornerRadius = 10
        
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
    
    
    func setupViews() {
        mainSource = [Item]()
        redSource = [Item]()
        blueSource = [Item]()
        
        for _ in 0..<9 {
            mainSource.append(Item(power: 0, side: .unknown))
        }
        for i in 1...6 {
            let item1 = Item(power: i, side: .red)
            let item2 = Item(power: i, side: .blue)
            redSource.append(item1)
            blueSource.append(item2)
        }
        reloadViews()
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
            self.setupViews()
        }))
        
        self.present(alert, animated: true)
    }
    
    private func addBackground() {
        let pastelView = PastelView(frame: view.bounds)
        
        pastelView.startPastelPoint = .top
        pastelView.endPastelPoint = .bottom
        pastelView.animationDuration = 7.0
        
        var colors = [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8904744485, green: 0.8502347224, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6813562978, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.6451833526, alpha: 1)]
        
//        if self.traitCollection.userInterfaceStyle == .dark {
            colors = [#colorLiteral(red: 0.2352941176, green: 0.2549019608, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.1058823529, green: 0.1490196078, blue: 0.1725490196, alpha: 1), #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.4588235294, alpha: 1)]
//        }
        colors = [#colorLiteral(red: 1, green: 0.1058823529, blue: 0.4196078431, alpha: 0.75), #colorLiteral(red: 0.2705882353, green: 0.7921568627, blue: 1, alpha: 0.75)]
        
        pastelView.setColors(colors)
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    private func removeSelections() {
        for i in blueSource {
            if i.isSelected {
                i.isSelected = false
                i.isRemoved = true
                i.side = .unknown
                i.power = 0
            }
        }
        
        for i in redSource {
            if i.isSelected {
                i.isSelected = false
                i.isRemoved = true
                i.side = .unknown
                i.power = 0
            }
        }
    }
    
    private func deselectAll() {
        for i in blueSource {
            if i.isSelected {
                i.isSelected = false
                i.isSelected = false
            }
        }
        
        for i in redSource {
            if i.isSelected {
                i.isSelected = false
            }
        }
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return 9
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.lab.text = ""
        var item: Item!
        switch collectionView {
        case mainCollectionView:
            item = mainSource[indexPath.row]
        case redCollectionView:
            item = redSource[indexPath.row]
        case blueCollectionView:
            item = blueSource[indexPath.row]
        default:
            break
        }
        cell.lab.text = "\(item.power)"
        cell.backgroundColor = item.color
        return cell
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case mainCollectionView:
            guard let selected = selected else { return }
            
            if selected.power == 0 { return }
            if selected.power <= mainSource[indexPath.row].power { return }
            mainSource[indexPath.row].power = selected.power
            mainSource[indexPath.row].side = selected.side
            self.selected = nil
            removeSelections()
            blueMove.toggle()
        case redCollectionView:
            if blueMove { break }
            deselectAll()
            if selected == redSource[indexPath.row] {
                selected = nil
            } else if selected != redSource[indexPath.row] {
                selected = redSource[indexPath.row]
                selected!.isSelected = true
            }
        case blueCollectionView:
            if !blueMove { break }
            deselectAll()
            if selected == blueSource[indexPath.row] {
                selected = nil
            } else if selected != blueSource[indexPath.row] {
                selected = blueSource[indexPath.row]
                selected!.isSelected = true
            }
        default:
            break
        }
        reloadViews()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        if collectionView == mainCollectionView {
            let cellWidth = (collectionViewWidth / 3) - 1
            return CGSize(width: cellWidth, height: cellWidth)
        }
        let cellWidth = (collectionViewWidth - 2) / 3
        return CGSize(width: cellWidth, height: cellWidth / 2)
    }
}


class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lab: UILabel!
}
