//
//  ViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 22.05.2021.
//

import UIKit

enum Side {
    case blue
    case red
    case unselected
}

struct Item: Equatable {
    var color: UIColor
    var power: Int
    var side: Side
}


class ViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var redCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    @IBOutlet weak var redHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blueHeightConstraint: NSLayoutConstraint!
    
    var mainSource = [Item]()
    var redSource = [Item]()
    var blueSource = [Item]()
    
    var selected: Item!
    
    var viewModel: ViewModel!

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
        
        let width = (blueCollectionView.bounds.width - (6 * 5)) / 6
        let height = (width * 2) + 5
        redHeightConstraint.constant = height
        blueHeightConstraint.constant = height
        
        selected = Item(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), power: 0, side: .unselected)
    }
    
    
    func setupViews() {
        mainSource = [Item]()
        redSource = [Item]()
        blueSource = [Item]()
        mainSource = Array(repeating: Item(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), power: 0, side: .unselected), count: 9)
        for i in 1...6 {
            let item1 = Item(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), power: i, side: .red)
            let item2 = Item(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), power: i, side: .blue)
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
        let alert = UIAlertController(title: "Do you want play again?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.setupViews()
        }))

//        self.present(alert, animated: true)
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
            if selected.power == 0 { return }
            if selected.power <= mainSource[indexPath.row].power { return }
            mainSource[indexPath.row] = selected
            selected.power = 0
        case redCollectionView:
            selected = redSource[indexPath.row]
            redSource[indexPath.row].power = 0
            redSource[indexPath.row].color = #colorLiteral(red: 0.2941176471, green: 0.3137254902, blue: 0.3411764706, alpha: 1)
        case blueCollectionView:
            selected = blueSource[indexPath.row]
            blueSource[indexPath.row].power = 0
            blueSource[indexPath.row].color = #colorLiteral(red: 0.2941176471, green: 0.3137254902, blue: 0.3411764706, alpha: 1)
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
        let cellWidth = (collectionViewWidth / 3) - 2
        return CGSize(width: cellWidth, height: cellWidth / 2)
    }
}


class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lab: UILabel!
}
