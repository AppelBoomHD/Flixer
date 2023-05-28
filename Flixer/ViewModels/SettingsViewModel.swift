//
//  SettingsViewModel.swift
//  Flixer
//
//  Created by Julian Riemersma on 10/02/2021.
//

import Combine
import Firebase
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var user: User?
    @Published var email: String = ""
    @Published var displayName: String = ""
    @ObservedObject var session: SessionStore
    
    private var cancellables = Set<AnyCancellable>()
    
    init(session: SessionStore) {
        self.session = session
        
        session.$user.compactMap { user in
            user?.email
        }
        .assign(to: \.email, on: self)
        .store(in: &cancellables)
        
        session.$user.compactMap { user in
            user?.displayName
        }
        .assign(to: \.displayName, on: self)
        .store(in: &cancellables)
    }
    
    func signInEmail(email: String, password: String) {
        session.signInEmail(email: email, password: password) { _, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                return
            }
        }
    }
    
    func signOut(completion: @escaping () -> Void) {
        session.signOut()
        completion()
    }
}
