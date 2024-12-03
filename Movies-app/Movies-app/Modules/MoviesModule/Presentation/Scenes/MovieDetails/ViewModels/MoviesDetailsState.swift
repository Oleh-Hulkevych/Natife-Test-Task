//
//  MoviesDetailsState.swift
//  Movies-app
//
//  Created by Oleh on 03.12.2024.
//

import Foundation

struct MoviesDetailsState {
    var movieTitle: String = ""
    var movieDetails: MovieDetails? = nil
    var trailerURLString: String? = nil
    var error: NetworkError? = nil
}
