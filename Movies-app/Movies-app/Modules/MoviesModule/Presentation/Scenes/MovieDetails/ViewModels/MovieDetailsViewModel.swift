//
//  MovieDetailsViewModel.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

protocol MovieDetailsViewModelProtocol { }

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    
    private let movieId: Int
    private let useCase: MoviesUseCaseProtocol
    
    init(movieId: Int, useCase: MoviesUseCaseProtocol) {
        self.movieId = movieId
        self.useCase = useCase
    }
}
