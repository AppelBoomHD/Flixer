//
//  LikedFilms.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import Firebase
import SDWebImageSwiftUI
import SwiftUI

struct LikedFilms: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var repository = LikedFilmRepository()
    
    @State var showingInfo = false
    
    init() {
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                    
                    ForEach(repository.films) { film in
                        VStack {
                            if (film.liked!.contains(session.uid ?? "")) && (film.liked!.contains(session.user?.linkedUser ?? "notAUser")) {
                                Button(action: {
                                    self.showingInfo = true
                                }) {
                                    cards(name: film.title, image: film.image)
                                        .padding(.horizontal)
                                }
                                
                                Divider()
                            }
                        }
                        .sheet(isPresented: $showingInfo, content: {
                            InfoSheet(film: film)
                        })
                    }
                }
            }
            .navigationBarTitle("Matched films")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(.black)
                }
            }
            .background(Color("white")
                .edgesIgnoringSafeArea(.all))
        }
    }
}

struct cards: View {
    var name = ""
    var image = ""
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: image)!).resizable().frame(width: 65, height: 65).clipShape(Circle())
            
            Text(name).fontWeight(.heavy)
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "info.circle")
        }
    }
}

struct LikedFilms_Previews: PreviewProvider {
    static var previews: some View {
        LikedFilms().environmentObject(SessionStore())
    }
}
