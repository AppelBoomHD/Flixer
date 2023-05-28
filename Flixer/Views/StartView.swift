//
//  StartView.swift
//  Flixer
//
//  Created by Julian Riemersma on 10/02/2021.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var repository: FilmRepository
    
    var body: some View {
        ZStack {
            if session.user != nil {
                HomeView()
                    .environmentObject(session)
                    .environmentObject(repository)
                
                if repository.films.isEmpty {
                    Loader()
                }
                
            } else {
                LoginView(loginViewModel: LoginViewModel(session: session))
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
