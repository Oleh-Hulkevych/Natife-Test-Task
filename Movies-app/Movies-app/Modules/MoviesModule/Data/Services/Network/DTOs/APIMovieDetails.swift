//
//  APIMovieDetails.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

struct APIMovieDetails: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let productionCountries: [APICountries]
    let genres: [APIGenre]
    let overview: String
    let rating: Double
    let video: Bool
    let votes: Int
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case genres
        case overview
        case rating = "vote_average"
        case video
        case votes = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
