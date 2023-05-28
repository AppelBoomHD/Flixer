//
//  SettingsView.swift
//  Flixer
//
//  Created by Julian Riemersma on 13/02/2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var isShowingInviteView = false
    
    var body: some View {
        ZStack {
            Color("offWhite").edgesIgnoringSafeArea(.all)
                
            VStack {
                HStack {
                    Spacer()
                
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(.black)
                    .padding()
                }
                
                Spacer()
            
                Button(action: {
                    self.settingsViewModel.signOut {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Sign out")
                }
                .buttonStyle(LightButtonStyle(paddingSize: 20, shape: RoundedRectangle(cornerRadius: 25)))
                
                Spacer()
            }
        }
    }
}
