//
//  MoviesCoordinatorProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

protocol MoviesCoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
    func showMovieDetails(with id: Int)
    func showPosterImage(_ imageURL: String)
    func showTrailerVideo(_ videoURL: String)
    func showSortActionSheet(
        from viewController: UIViewController,
        currentOption: SortOption,
        sourceButton: UIBarButtonItem,
        onSelect: @escaping (SortOption) -> Void
    )
    func showAlert(
        from viewController: UIViewController,
        title: String,
        message: String?,
        buttonTitle: String
    )
}
