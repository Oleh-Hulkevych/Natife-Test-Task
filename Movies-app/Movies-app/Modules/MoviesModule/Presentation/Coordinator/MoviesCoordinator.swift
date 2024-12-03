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
    
    func showSortActionSheet(
        from viewController: UIViewController,
        currentOption: SortOption,
        sourceButton: UIBarButtonItem,
        onSelect: @escaping (SortOption) -> Void
    ) {
        let alert = UIAlertController(
            title: LocalizedKey.sortOptionsTitle.localizedString,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        SortOption.allCases.forEach { option in
            let action = UIAlertAction(
                title: option.title,
                style: .default
            ) { _ in
                onSelect(option)
            }
            if option == currentOption {
                action.setValue(true, forKey: "checked")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(
            title: LocalizedKey.sortOptionsCancelButton.localizedString,
            style: .cancel
        ))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sourceButton
        }
        
        viewController.present(alert, animated: true)
    }
    
    func showAlert(
        from viewController: UIViewController,
        title: String,
        message: String?,
        buttonTitle: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        viewController.present(alert, animated: true)
    }
}
