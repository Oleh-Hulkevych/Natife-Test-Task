//
//  MovieDetails.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import Foundation

struct MovieDetails {
    let id: Int
    let genres: [APIGenre]
    let title: String
    let countries: [String]
    let year: String
    let rating: Double
    let votes: Int
    let overview: String
    let video: Bool
    let posterImageURLString: String?
    let backdropImageURLString: String?
}

extension MovieDetails {
    init(from apiDetails: APIMovieDetails) {
        self.id = apiDetails.id
        self.genres = apiDetails.genres
        self.title = apiDetails.title
        self.countries = apiDetails.productionCountries.map { $0.name }
        self.year = String(apiDetails.releaseDate.prefix(4))
        self.rating = apiDetails.rating
        self.votes = apiDetails.votes
        self.overview = apiDetails.overview
        self.video = apiDetails.video
        self.posterImageURLString = apiDetails.posterPath.map { $0 }
        self.backdropImageURLString = apiDetails.backdropPath.map { $0 }
    }
}
