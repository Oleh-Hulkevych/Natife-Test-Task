//
//  MoviesCoordinator.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

final class MoviesCoordinator: MoviesCoordinatorProtocol {
    
    let navigationController: UINavigationController
    private let factory: MoviesFactoryProtocol
    
    init(
        navigationController: UINavigationController,
        factory: MoviesFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewController = factory.makeMoviesFeedViewController(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showMovieDetails(with id: Int) {
        let viewController = factory.makeMovieDetailsViewController(
            movieId: id,
            coordinator: self
        )
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showPosterImage(_ imageURL: String) {
        let viewController = factory.makePosterViewController(imageURL: imageURL)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
    
    func showTrailerVideo(_ videoURL: String) {
        let viewController = factory.makeTrailerViewController(videoURL: videoURL)
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
}
