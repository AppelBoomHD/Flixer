//
//  InfoSheet.swift
//  Flixer
//
//  Created by Julian Riemersma on 13/02/2021.
//

import Kingfisher
import SwiftUI

struct InfoSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var film: Film
    
    var body: some View {
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
            
            KFImage(URL(string: film.image))
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 12)
            
            Text(film.title)
                .font(.title)
                .bold()
                .foregroundColor(.black)
            
            HStack {
                Image("camera")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text(":  \(film.type)")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
                
                Image("star")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(":  \(film.rating)")
                    .font(.title)
                    .foregroundColor(.black)
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Synopsis:")
                        .bold()
                    Text(film.synopsis)
                }
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Release date:")
                            .bold()
                        Text(film.released)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Duration:")
                            .bold()
                        Text(film.runtime)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Downloadable:")
                            .bold()
                        Text(film.download == "0" ? "Nee" : "Ja")
                    }
                }
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer()
        }
        .background(Color("white")
            .edgesIgnoringSafeArea(.all))
    }
}

struct InfoSheet_Previews: PreviewProvider {
    static var previews: some View {
        InfoSheet(film: Film.test.first!)
    }
}
