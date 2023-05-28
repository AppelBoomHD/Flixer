//
//  User.swift
//  Flixer
//
//  Created by Julian Riemersma on 10/02/2021.
//

import FirebaseFirestoreSwift
import Foundation

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var displayName: String
    var linkedUser: String?
}
