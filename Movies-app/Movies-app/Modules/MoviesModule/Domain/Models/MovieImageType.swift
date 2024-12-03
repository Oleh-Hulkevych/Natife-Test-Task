//
//  MovieImageType.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

enum MovieImageType {
    case poster
    case backdrop
    
    func getPath(from movie: Movie) -> String? {
        switch self {
        case .poster:
            return movie.posterImageURLString
        case .backdrop:
            return movie.backdropImageURLString
        }
    }
}
