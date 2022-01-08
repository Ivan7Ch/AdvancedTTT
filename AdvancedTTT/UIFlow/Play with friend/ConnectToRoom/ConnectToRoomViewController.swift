//
//  ConnectToRoomViewController.swift
//  AdvancedTTT
//
//  Created by User on 08.01.2022.
//

import UIKit

class ConnectToRoomViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var connectToRoomButton: UIButton!
    @IBOutlet weak var createNewRoomButton: UIButton!
    
    private let roomNumberLenght = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
    }
    
    @IBAction func connectToRoomButtonAction() {
        if let text = textField.text, text.count == roomNumberLenght {
            checkIfRoomExists(roomNumber: text, res: { [weak self] exists in
                if exists {
                    self?.showVC(with: .red, roomNumber: text)
                }
            })
        }
    }
    
    @IBAction func createNewRoomButtonAction() {
        let number = String(Int.random(in: 100000...999999))
        checkIfRoomExists(roomNumber: number, res: { [weak self] exists in
            if !exists {
                FirebaseHelper(room: number).writeData(data: RawGameData(field: "aaaaaaaaa", isBlueMove: true))
                self?.showMessage(number: number)
            } else {
                self?.createNewRoomButtonAction()
            }
        })
    }
    
    private func showMessage(number: String) {
        let alert = UIAlertController(title: number, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play", style: .default, handler: { [weak self] _ in
            self?.showVC(with: .blue, roomNumber: number)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showVC(with boardType: BoardType, roomNumber: String) {
        if let vc = storyboard?.instantiateViewController(identifier: "PlayOnlineViewController") as? PlayOnlineViewController {
            vc.playerBoardType = boardType
            vc.roomNumber = roomNumber
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkIfRoomExists(roomNumber: String, res: @escaping (Bool) -> Void) {
        FirebaseHelper(room: roomNumber).isRoomExists({ exists in
            res(exists)
        })
    }
}

extension ConnectToRoomViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= roomNumberLenght
    }
}
