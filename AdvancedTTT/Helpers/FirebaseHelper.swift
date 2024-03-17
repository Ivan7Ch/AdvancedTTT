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
    let blueItems: String?
    let redItems: String?
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
            let blueItems = data["bi"] as? String
            let redItems = data["ri"] as? String
            
            completion(RawGameData(field: field, isBlueMove: isBlueMove, roomNumber: roomNumber, bluePlayer: bluePlayer, redPlayer: redPlayer, blueItems: blueItems, redItems: redItems))
        }
    }
    
    func writeData(data: RawGameData) {
        ref?.setData(["f" : data.field,
                      "b" : data.isBlueMove,
                      "n" : data.roomNumber,
                      "bp" : data.bluePlayer ?? "",
                      "rp" : data.redPlayer ?? "",
                      "bi" : data.blueItems ?? "",
                      "ri" : data.redItems ?? ""])
    }
    
    func updateData(data: RawGameData) {
        var dict = ["f" : data.field,
                    "b" : data.isBlueMove,
                    "n" : data.roomNumber,
                    "bp" : data.bluePlayer ?? "",
                    "rp" : data.redPlayer ?? ""] as [String : Any]
        if let bi = data.blueItems {
            dict["bi"] = bi
        }
        
        if let ri = data.redItems {
            dict["ri"] = ri
        }
        
        ref?.updateData(dict)
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
    
    func getContentURL(for contentType: ContentType, _ completion: @escaping ((String?) -> Void)) {
        let contentCollection = database.collection("content")
        
        contentCollection.document(contentType.rawValue).getDocument { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else {
                completion(nil)
                return
            }
            
            if let contentURL = data["url"] as? String {
                completion(contentURL)
            } else {
                completion(nil)
            }
        }
    }
}
