//
//  LoginView.swift
//  Flixer
//
//  Created by Julian Riemersma on 13/02/2021.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var loginViewModel: LoginViewModel
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.1960784314, green: 0.2352941176, blue: 0.2549019608, alpha: 1)), Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.1176470588, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            KeyboardHost {
                VStack {
                    Spacer()
                    HStack {
                        Text("Login")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "envelope")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(width: 35)
                        
                        ZStack(alignment: .leading) {
                            if email.isEmpty { Text("Email").foregroundColor(.gray) }
                            TextField("", text: $email)
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                        }
                    }
                    .padding()
                    .background(Color("lightGrey"))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "lock")
                            .font(.title)
                            .foregroundColor(.black)
                            .frame(width: 35)
                        
                        ZStack(alignment: .leading) {
                            if password.isEmpty { Text("Password").foregroundColor(.gray) }
                            SecureField("", text: $password)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    .background(Color("lightGrey"))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    
                    Button(action: { self.loginViewModel.signInEmail(email: self.email, password: self.password) }) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.pink)
                            .cornerRadius(15.0)
                    }
                    .buttonStyle(DarkButtonStyle(paddingSize: 10, shape: RoundedRectangle(cornerRadius: 25)))
                    Spacer()
                }
                .padding()
                .alert(isPresented: $loginViewModel.showingAlert) {
                    Alert(title: Text("Failed to sign in"), message: loginViewModel.alertInfo, dismissButton: .default(Text("Try again")))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginViewModel: LoginViewModel(session: SessionStore()))
    }
}
