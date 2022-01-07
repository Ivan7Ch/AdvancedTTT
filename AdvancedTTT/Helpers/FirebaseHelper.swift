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
}

class FirebaseHelper {
    
    let database = Firestore.firestore()
    let ref: DocumentReference
    
    init(room: String) {
        ref = database.document("rooms/\(room)")
    }
    
    func listenField(_ completion: @escaping ((RawGameData?) -> Void)) {
        ref.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot, let data = document.data() else { return }
            
            guard let field = data["f"] as? String,
                  let isBlueMove = data["b"] as? Bool else { return }
            completion(RawGameData(field: field, isBlueMove: isBlueMove))
        }
    }
    
    func writeData(data: RawGameData) {
        ref.setData(["f" : data.field, "b" : data.isBlueMove])
    }
}
