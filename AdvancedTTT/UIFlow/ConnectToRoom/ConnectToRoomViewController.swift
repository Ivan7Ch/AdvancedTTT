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
        
        [textField, connectToRoomButton, createNewRoomButton].forEach({ view in
            view?.layer.cornerRadius = Constants.generalCornerRadius
        })
        
        textField.delegate = self
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
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func checkIfRoomExists(roomNumber: String, res: @escaping (Bool) -> Void) {
//        ProgressHUD.show()
        FirebaseHelper(room: roomNumber).isRoomExists({ exists in
//            ProgressHUD.dismiss()
            res(exists)
        })
    }
    
    func getRoomNumber(res: @escaping (String?) -> Void) {
//        ProgressHUD.show()
        FirebaseHelper().getHighestRoomNumber() { roomNumber in
//            ProgressHUD.dismiss()
            res(roomNumber)
        }
    }
}


//TODO: - Actions
extension ConnectToRoomViewController {
    
    @IBAction func connectToRoomButtonAction() {
        textField.resignFirstResponder()
//        ProgressHUD.show()
        if let text = textField.text, text.count == roomNumberLenght {
            checkIfRoomExists(roomNumber: text, res: { [weak self] exists in
//                ProgressHUD.dismiss()
                if exists {
                    self?.showVC(with: .red, roomNumber: text)
                }
            })
        } else {
//            ProgressHUD.dismiss()
        }
    }
    
    @IBAction func createNewRoomButtonAction() {
        textField.resignFirstResponder()
//        ProgressHUD.show()
        getRoomNumber(res: { [weak self] roomNumber in
//            ProgressHUD.dismiss()
            var newNumberString = "000000"
            if let roomNumber = roomNumber, let num = Int(roomNumber) {
                newNumberString = String(format: "%06d", num + 1)
            }
            let data = RawGameData(field: "aaaaaaaaa", isBlueMove: true, roomNumber: newNumberString, bluePlayer: LocalStorageHelper.uniquePlayerID, redPlayer: nil, blueItems: GameFieldCoder.allBlueItems, redItems: GameFieldCoder.allRedItems)
            FirebaseHelper(room: newNumberString).writeData(data: data)
            self?.showMessage(number: newNumberString)
        })
    }
}


//TODO: - UITextFieldDelegate
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
