//
//  Film.swift
//  Flixer
//
//  Created by Julian Riemersma on 03/02/2021.
//

import FirebaseFirestoreSwift
import Foundation
import SwiftUI

struct Film: Codable, Identifiable {
    var id: String
    var title: String
    var image: String
    var synopsis: String
    var rating: String
    var type: String
    var released: String
    var runtime: String
    var largeimage: String
    var unogsdate: String
    var imdbid: String
    var download: String
    var liked: [String]?
    var disliked: [String]?
    var swipe: CGFloat = 0
    var degree: Double = 0

    static var placeholder: [Film] { [
        .init(id: "", title: "", image: "", synopsis: "", rating: "", type: "", released: "", runtime: "", largeimage: "", unogsdate: "", imdbid: "", download: "", liked: [""], disliked: [""])
    ] }

    static var test: [Film] { [
        .init(id: "1", title: "Homecoming", image: "https://occ-0-2912-64.1.nflxso.net/dnm/api/v6/evlCitJPPCVCry0BZlEFb5-QjKc/AAAABXEfLifHezJ8GJ9GXqY8NhPVv966OMweAKlf34Ju26c-YLEhoNQPFnbmVA_-iP6hDjQIIUzDWlValhKd6C1qfZUKYQ.jpg?r=12d", synopsis: "In a series of stories that take place in Singapore and Malaysia, a group of individuals heads home for Lunar New Year but face hysterical roadblocks.", rating: "7.5", type: "movie", released: "2011", runtime: "1h32m", largeimage: "largeimage", unogsdate: "2021-02-11", imdbid: "tt7008682", download: "0")
    ] }
}
