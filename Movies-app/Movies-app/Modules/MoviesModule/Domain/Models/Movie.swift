//
//  Movie.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Foundation

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

extension Movie {
   init(from apiMovie: APIMovie, genres: [APIGenre]) {
       self.id = apiMovie.id
       self.rating = apiMovie.rating ?? 0.0
       self.votes = apiMovie.votes ?? 0
       self.year = apiMovie.releaseDate.map { String($0.prefix(4)) } ?? "N/A"
       self.title = apiMovie.title
       self.posterImageURLString = apiMovie.posterPath.map { $0 }
       self.backdropImageURLString = apiMovie.backdropPath.map { $0 }
       self.genres = genres.filter { apiMovie.genresIDs?.contains($0.id) ?? false }
       self.video = apiMovie.video ?? false
   }
    
    func getImageURL(type: MovieImageType, size: ImageSizeQuery) -> URL? {
        guard let path = type.getPath(from: self) else { return nil }
        let urlString = APIConstants.baseImageUrl + size.rawValue + path
        return URL(string: urlString)
    }
}

extension Array where Element == Movie {
    func sorted(by option: SortOption) -> [Movie] {
        switch option {
        case .nameAscending:
            return self.sorted { $0.title < $1.title }
        case .ratingDescending:
            return self.sorted { $0.rating > $1.rating }
        case .votesDescending:
            return self.sorted { $0.votes > $1.votes }
        case .defaultOption:
            return self
        }
    }
}
