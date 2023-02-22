//
//  FirebaseHelper.swift
//  AdvancedTTT
//
//  Created by User on 07.01.2022.
//

import FirebaseFirestore

struct RawGameData {
    let field: String
    let isBlueMove: Bool
    let roomNumber: String
    let bluePlayer: String?
    let redPlayer: String?
}

class FirebaseHelper {
    
    let database = Firestore.firestore()
    let ref: DocumentReference?
    
    init(room: String) {
        ref = database.document("rooms/\(room)")
    }
    
    init() {
        ref = nil
    }
    
    func listenField(_ completion: @escaping ((RawGameData?) -> Void)) {
        ref?.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else { return }
            
            guard let field = data["f"] as? String,
                  let isBlueMove = data["b"] as? Bool,
                  let roomNumber = data["n"] as? String
            else { return }
            let bluePlayer = data["bp"] as? String
            let redPlayer = data["rp"] as? String
            
            completion(RawGameData(field: field, isBlueMove: isBlueMove, roomNumber: roomNumber, bluePlayer: bluePlayer, redPlayer: redPlayer))
        }
    }
    
    func writeData(data: RawGameData) {
        ref?.setData(["f" : data.field, "b" : data.isBlueMove, "n" : data.roomNumber, "bp" : data.bluePlayer ?? "", "rp" : data.redPlayer ?? ""])
    }
    
    func isRoomExists(_ completion: @escaping ((Bool) -> Void)) {
        ref?.getDocument { (document, error) in
            guard let document = document else {
                completion(false)
                return
            }
            completion(document.exists)
        }
    }
    
    func getHighestRoomNumber(_ completion: @escaping ((String?) -> Void)) {
        database.collection("rooms").order(by: "n", descending: true).limit(to: 1).getDocuments(completion: { (querySnapshot, error) in
            if let document = querySnapshot?.documents.first {
                let data = document.data()
                completion(data["n"] as? String)
            } else {
                completion(nil)
            }
        })
    }
}
