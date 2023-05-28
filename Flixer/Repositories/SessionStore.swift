//
//  SessionStore.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import Combine
import Firebase
import Foundation

class SessionStore: ObservableObject {
    @Published var isLoading = false
    @Published var user: UserModel?
    @Published var uid: String?
    
    let db: Firestore = .firestore()
    var handle: AuthStateDidChangeListenerHandle?
    
    var usersPath = "users"
    
    init() {
        listen()
    }
    
    func listen() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        // monitor authentication changes using firebase
        handle = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.uid = user.uid
                
                self.db.collection("users").document(user.uid).addSnapshotListener { snapshot, error in
                    if let error = error {
                        self.user = nil
                        print(error.localizedDescription)
                    } else {
                        self.user = try? snapshot?.data(as: UserModel.self)
                    }
                }
            } else {
                // if we don't have a user, set our session to nil
                self.user = nil
            }
        }
    }
    
    func signUpEmail(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signInEmail(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
    ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signInAnonymous() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously()
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Succesfully signed out")
        } catch {
            print("Error when trying to sign out: \(error.localizedDescription)")
        }
    }
    
    func invite(email: String) {}
}
