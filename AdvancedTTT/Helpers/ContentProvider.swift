//
//  ContentProvider.swift
//  AdvancedTTT
//
//  Created by Ivan Chernetskiy on 16.08.2023.
//

import Foundation

enum ContentType: String {
    case logo = "logo"
}

class ContentProvider {
    
    static private let firebaseHelper = FirebaseHelper()
    
    // Update logo image on the main screen (HomeViewController)
    // size 300x120
    static func updateLogo(completion: @escaping (String?) -> Void) {
        firebaseHelper.getContentURL(for: .logo) { url in
            if let url = url {
                completion(url)
            } else {
                //TODO: - handle error if needed
                print("Logo URL not found.")
            }
        }
    }
}
