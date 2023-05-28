//
//  LoginViewModel.swift
//  Flixer
//
//  Created by Julian Riemersma on 10/02/2021.
//

import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @ObservedObject var session: SessionStore
    @Published var showingAlert = false
    @Published var alertInfo = Text("")

    init(session: SessionStore) {
        self.session = session
    }

    func signInEmail(email: String, password: String) {
        session.signInEmail(email: email, password: password) { _, error in
            if let error = error {
                self.alertInfo = Text(error.localizedDescription)
                self.showingAlert = true
            } else {
                return
            }
        }
    }

    func signOut() {
        session.signOut()
    }
}
