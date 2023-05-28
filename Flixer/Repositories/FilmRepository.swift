//
//  FilmRepository.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import Combine
import Firebase
import SwiftUI

class FilmRepository: ObservableObject {
    let db: Firestore = .firestore()
    
    @Published var films = [Film]()
    @Published var lastFilms = [Film]()
    @Published var last = -1
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFilms()
        
        $films
            .receive(on: DispatchQueue.main)
            .sink { films in
                if films.count > 5 {
                    self.lastFilms.append(contentsOf: self.films[self.films.count - 5...self.films.count - 1])
                } else {
                    self.lastFilms = films
                }
            }
            .store(in: &cancellables)
    }
    
    func loadFilms() {
        db.collection("films")
            .getDocuments { querySnapshot, error in
                
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
                    
                    if disliked?.contains(Auth.auth().currentUser?.uid ?? "") ?? false {
                        return nil
                    } else if liked?.contains(Auth.auth().currentUser?.uid ?? "") ?? false {
                        return nil
                    }
                    
                    return Film(id: id, title: title, image: image, synopsis: synopsis, rating: rating, type: type, released: released, runtime: runtime, largeimage: largeimage, unogsdate: unogsdate, imdbid: imdbid, download: download, liked: liked, disliked: disliked)
                }
            }
    }
    
    func loadMoreFilmsIfNeeded(currentFilm film: Film?) {
        guard let film = film else {
            return
        }

        let thresholdIndex = 2
        if lastFilms.firstIndex(where: { $0.id == film.id }) == thresholdIndex {
            print("updating films!")
            
            if films.count - lastFilms.count > 5 {
                lastFilms.insert(contentsOf: films[films.count - lastFilms.count - 5...films.count - lastFilms.count], at: 0)
                last += 5
            } else if films.count - lastFilms.count > 0 {
                lastFilms.insert(contentsOf: films[0...films.count - lastFilms.count], at: 0)
                last += 5
            }
        }
    }
    
    func update(film: Film, value: CGFloat, degree: Double) {
        for i in 0..<lastFilms.count {
            if lastFilms[i].id == film.id {
                lastFilms[i].swipe = value
                lastFilms[i].degree = degree
                last = i
            }
        }
    }
    
    func updateDB(film: Film, status: String) {
        loadMoreFilmsIfNeeded(currentFilm: film)
        
        let db = Firestore.firestore()
        
        if status == "liked" {
            db.collection("liked").document(film.id).setData([
                "netflixid": film.id,
                "title": film.title,
                "image": film.image,
                "synopsis": film.synopsis,
                "rating": film.rating,
                "type": film.type,
                "released": film.released,
                "runtime": film.runtime,
                "largeimage": film.largeimage,
                "unogsdate": film.unogsdate,
                "imdbid": film.imdbid,
                "download": film.download,
                "liked": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
            ], merge: true) { err in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
            }
            
            db.collection("films").document(film.id).updateData([
                "liked": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
            ]) { err in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                print("liked")
            }
            
        } else if status == "reject" {
            db.collection("films").document(film.id).updateData([
                "disliked": FieldValue.arrayUnion([Auth.auth().currentUser!.uid])
            ]) { err in
                
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                print("rejected")
            }
        }
        
        for i in 0..<lastFilms.count {
            if lastFilms[i].id == film.id {
                if status == "liked" {
                    lastFilms[i].swipe = 500
                } else if status == "reject" {
                    lastFilms[i].swipe = -500
                } else {
                    lastFilms[i].swipe = 0
                }
            }
        }
    }
}
