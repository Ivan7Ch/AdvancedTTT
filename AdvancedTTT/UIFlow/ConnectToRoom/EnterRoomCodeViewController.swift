//
//  EnterRoomCodeViewController.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 01.09.2023.
//

import UIKit

class EnterRoomCodeViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    private let roomNumberLenght = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //TODO: show activity indicator
        FirebaseHelper(room: roomNumber).isRoomExists({ exists in
            //TODO: dismiss activity indicator
            res(exists)
        })
    }
    
    func getRoomNumber(res: @escaping (String?) -> Void) {
        //TODO: show activity indicator
        FirebaseHelper().getHighestRoomNumber() { roomNumber in
            //TODO: dismiss activity indicator
            res(roomNumber)
        }
    }
}


//TODO: - Actions
extension EnterRoomCodeViewController {
    
    @IBAction func connectToRoomButtonAction() {
        textField.resignFirstResponder()
        //TODO: show activity indicator
        if let text = textField.text, text.count == roomNumberLenght {
            checkIfRoomExists(roomNumber: text, res: { [weak self] exists in
                //TODO: dismiss activity indicator
                if exists {
                    self?.showVC(with: .red, roomNumber: text)
                }
            })
        } else {
            //TODO: dismiss activity indicator
        }
    }
}


//TODO: - UITextFieldDelegate
extension EnterRoomCodeViewController: UITextFieldDelegate {
    
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
