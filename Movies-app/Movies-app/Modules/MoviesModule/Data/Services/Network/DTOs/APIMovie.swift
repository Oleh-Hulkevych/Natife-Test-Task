//
//  APIMovie.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

struct APIMovie: Codable {
    let id: Int
    let rating: Double?
    let votes: Int?
    let releaseDate: String?
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let genresIDs: [Int]?
    let video: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case rating = "vote_average"
        case votes = "vote_count"
        case releaseDate = "release_date"
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genresIDs = "genre_ids"
        case video
    }
}
