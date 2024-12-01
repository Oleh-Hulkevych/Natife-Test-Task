//
//  Movie.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

struct Movie {
    let id: Int
    let rating: Double
    let votes: Int
    let year: String
    let title: String
    let posterImageURLString: String?
    let backdropImageURLString: String?
    let genres: [APIGenre]
    let video: Bool
}

/// Note: If mapping logic required complex processing or additional dependencies,
/// it would make more sense to use a custom mapper with protocol approach.
/// However, in this case with straightforward one-to-one mapping,
/// using an extension is a simpler and cleaner solution.
extension Movie {
   init(from apiMovie: APIMovie, genres: [APIGenre]) {
       self.id = apiMovie.id
       self.rating = apiMovie.rating
       self.votes = apiMovie.votes
       self.year = String(apiMovie.releaseDate.prefix(4))
       self.title = apiMovie.title
       self.posterImageURLString = apiMovie.posterPath.map { APIConstants.baseImageUrl + $0 }
       self.backdropImageURLString = apiMovie.backdropPath.map { APIConstants.baseImageUrl + $0 }
       self.genres = genres.filter { apiMovie.genresIDs.contains($0.id) }
       self.video = apiMovie.video
   }
}
