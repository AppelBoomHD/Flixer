//
//  LikedFilmRepository.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import Combine
import Firebase
import Foundation

class LikedFilmRepository: ObservableObject {
    @Published var films = [Film]()
    let db: Firestore = .firestore()
    
    init() {
        db.collection("liked").getDocuments { querySnapshot, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.films = querySnapshot!.documents.compactMap { document -> Film? in
                let id = document.get("netflixid") as! String
                let title = document.get("title") as! String
                let image = document.get("image") as! String
                let synopsis = document.get("synopsis") as! String
                let rating = document.get("rating") as! String
                let type = document.get("type") as! String
                let released = document.get("released") as! String
                let runtime = document.get("runtime") as! String
                let largeimage = document.get("largeimage") as! String
                let unogsdate = document.get("unogsdate") as! String
                let imdbid = document.get("imdbid") as! String
                let download = document.get("download") as! String
                let liked = document.get("liked") as? [String]
                let disliked = document.get("disliked") as? [String]
                
                return Film(id: id, title: title, image: image, synopsis: synopsis, rating: rating, type: type, released: released, runtime: runtime, largeimage: largeimage, unogsdate: unogsdate, imdbid: imdbid, download: download, liked: liked, disliked: disliked)
            }
        }
    }
}
