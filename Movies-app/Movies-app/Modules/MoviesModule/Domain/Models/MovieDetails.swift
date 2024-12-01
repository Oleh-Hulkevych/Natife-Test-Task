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

/// Note: If mapping logic required complex processing or additional dependencies,
/// it would make more sense to use a custom mapper with protocol approach.
/// However, in this case with straightforward one-to-one mapping,
/// using an extension is a simpler and cleaner solution.
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
        self.posterImageURLString = apiDetails.posterPath.map { APIConstants.baseImageUrl + $0 }
        self.backdropImageURLString = apiDetails.backdropPath.map { APIConstants.baseImageUrl + $0 }
    }
}
