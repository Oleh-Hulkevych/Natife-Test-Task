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
    
    func makeMovieDetailsViewController(movieId: Int, coordinator: MoviesCoordinator) -> UIViewController {
        let viewModel = MovieDetailsViewModel(movieId: movieId, useCase: useCase)
        return MovieDetailsViewController(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makePosterViewController(imageURL: String) -> UIViewController {
        let viewModel = PosterViewModel(imageURL: imageURL)
        let viewController = PosterViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return UIViewController()
    }
    
    func makeTrailerViewController(videoURL: String) -> UIViewController {
        let viewModel = TrailerViewModel(videoURL: videoURL)
        let viewController = TrailerViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .automatic
        return UIViewController()
    }
}
