//
//  ViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskyi on 22.05.2021.
//

import UIKit

struct Item {
    var color: UIColor
    var power: Int
}


class ViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var redCollectionView: UICollectionView!
    @IBOutlet weak var blueCollectionView: UICollectionView!
    
    var mainSource = [Item]()
    var redSource = [Item]()
    var blueSource = [Item]()
    
    var selected: Item!
    
    let viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        setupViews()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        redCollectionView.delegate = self
        redCollectionView.dataSource = self
        blueCollectionView.delegate = self
        blueCollectionView.dataSource = self
    }
    
    
    func setupViews() {
        mainSource = [Item]()
        redSource = [Item]()
        blueSource = [Item]()
        mainSource = Array(repeating: Item(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), power: 0), count: 9)
        for i in 1...6 {
            let item1 = Item(color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), power: i)
            let item2 = Item(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), power: i)
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
        let alert = UIAlertController(title: "Blue is winner", message: "Play again?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.setupViews()
        }))

        self.present(alert, animated: true)
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
            redSource[indexPath.row].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case blueCollectionView:
            selected = blueSource[indexPath.row]
            blueSource[indexPath.row].power = 0
            blueSource[indexPath.row].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        default:
            break
        }
        reloadViews()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = collectionView.bounds.width
        if collectionView == mainCollectionView {
            let cellWidth = (collectionViewWidth / 3) - 10
            return CGSize(width: cellWidth, height: cellWidth)
        }
        let cellWidth = (collectionViewWidth / 6) - 10
        return CGSize(width: cellWidth, height: cellWidth)
    }
}


class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lab: UILabel!
}
