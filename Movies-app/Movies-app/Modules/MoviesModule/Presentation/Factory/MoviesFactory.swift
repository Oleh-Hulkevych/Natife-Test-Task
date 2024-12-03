//
//  Untitled.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

final class MoviesFactory: MoviesFactoryProtocol {
    
    private let useCase: MoviesUseCaseProtocol
    
    init(useCase: MoviesUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func makeMoviesFeedViewController(coordinator: MoviesCoordinator) -> UIViewController {
        let viewModel = MoviesFeedViewModel(useCase: useCase)
        return MoviesFeedViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeMovieDetailsViewController(movieId: Int, movieTitle: String, coordinator: MoviesCoordinator) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movieId: movieId, movieTitle: movieTitle, useCase: useCase)
        return MovieDetailsViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makePosterViewController(imageURL: String) -> UIViewController {
        PosterViewController(imageURL: imageURL)
    }
    
    func makeTrailerViewController(videoURL: String) -> UIViewController {
        TrailerViewController(urlString: videoURL)
    }
}
