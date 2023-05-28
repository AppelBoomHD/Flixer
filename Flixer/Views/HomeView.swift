//
//  ContentView.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import Firebase
import Kingfisher
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var repository: FilmRepository
    @EnvironmentObject var session: SessionStore
    
    @State var showingLikedFilms = false
    @State var showingSettings = false
    
    var body: some View {
        ZStack {
            Color("white")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack(spacing: 15) {
                    Button(action: {
                        showingSettings = true
                    }, label: {
                        Image("menu")
                            .renderingMode(.template)
                    })
                    .sheet(isPresented: $showingSettings, content: {
                        SettingsView(settingsViewModel: SettingsViewModel(session: session))
                    })
                    
                    Text("Flixer")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        showingLikedFilms = true
                    }, label: {
                        Image("heart")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding()
                    })
                    .sheet(isPresented: $showingLikedFilms, content: {
                        LikedFilms()
                            .environmentObject(repository)
                            .environmentObject(session)
                    })
                }
                .foregroundColor(.black)
                .padding()
                
                GeometryReader { g in
                    
                    ZStack {
                        ForEach(repository.lastFilms) { film in
                            CardView(film: film, frame: g.frame(in: .global))
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            
            .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.all))
        }
    }
}

struct CardView: View {
    @EnvironmentObject var repository: FilmRepository
    var film: Film
    
    @State var showingInfo = false
    var frame: CGRect
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            if film.largeimage != "" {
                KFImage(URL(string: film.largeimage))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
            } else if film.image != "" {
                KFImage(URL(string: film.image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
            } else {
                Image("camera")
                    .background(Color.black)
                    .frame(width: frame.width, height: frame.height)
            }
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                (film.swipe > 0 ? Color.green : Color("red"))
                    .opacity(film.swipe != 0 ? 0.7 : 0)
                
                HStack {
                    if film.swipe < 0 {
                        Spacer()
                    }
                    
                    Text(film.swipe == 0 ? "" : (film.swipe > 0 ? "Liked" : "Rejected"))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 25)
                        .padding(.horizontal)
                    
                    if film.swipe > 0 {
                        Spacer()
                    }
                }
            })
            
            LinearGradient(gradient: .init(colors: [Color.black.opacity(0), Color.black.opacity(0.4)]), startPoint: .center, endPoint: .bottom)
            
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(film.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Rating: \(film.rating)")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                }
                
                HStack(spacing: 25) {
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        withAnimation(Animation.easeIn(duration: 0.8)) {
                            if self.repository.last == -1 {
                                self.repository.updateDB(film: self.repository.lastFilms[self.repository.lastFilms.count - 1], status: "reject")
                            } else {
                                self.repository.updateDB(film: self.repository.lastFilms[self.repository.last - 1], status: "reject")
                            }
                        }
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.all, 20)
                            .background(Color("red"))
                            .clipShape(Circle())
                    })
                    
                    Button(action: {
                        self.showingInfo = true
                        
                    }, label: {
                        Image(systemName: "info")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.all, 20)
                            .background(Color.purple)
                            .clipShape(Circle())
                    })
                    .sheet(isPresented: $showingInfo, content: {
                        InfoSheet(film: film)
                    })
                    
                    Button(action: {
                        withAnimation(Animation.easeIn(duration: 0.8)) {
                            if self.repository.last == -1 {
                                self.repository.updateDB(film: self.repository.lastFilms[self.repository.lastFilms.count - 1], status: "liked")
                            } else {
                                self.repository.updateDB(film: self.repository.lastFilms[self.repository.last - 1], status: "liked")
                            }
                        }
                        
                    }, label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding(.all, 20)
                            .background(Color.green)
                            .clipShape(Circle())
                    })
                    
                    Spacer(minLength: 0)
                }
            }
            .padding(.all)
        })
        .cornerRadius(20)
        .offset(x: film.swipe)
        .rotationEffect(.init(degrees: film.swipe == 0 ? 0 : (film.swipe > 0 ? 12 : -12)))
        .gesture(
            DragGesture()
                .onChanged { value in
                    
                    withAnimation(.default) {
                        if value.translation.width > 0 {
                            self.repository.update(film: film, value: value.translation.width, degree: 8)
                        } else {
                            self.repository.update(film: film, value: value.translation.width, degree: -8)
                        }
                    }
                }
                .onEnded { _ in
                    
                    withAnimation(.easeIn) {
                        if film.swipe > 150 {
                            self.repository.update(film: film, value: 500, degree: 0)
                            self.repository.updateDB(film: film, status: "liked")
                            
                        } else if film.swipe < -150 {
                            self.repository.update(film: film, value: -500, degree: 0)
                            self.repository.updateDB(film: film, status: "reject")
                            
                        } else {
                            self.repository.update(film: film, value: 0, degree: 0)
                        }
                    }
                }
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
