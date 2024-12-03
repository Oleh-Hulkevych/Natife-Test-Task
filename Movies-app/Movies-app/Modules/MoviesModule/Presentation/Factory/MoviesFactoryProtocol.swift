//
//  MoviesFactoryProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

protocol MoviesFactoryProtocol {
    func makeMoviesFeedViewController(coordinator: MoviesCoordinator) -> UIViewController
    func makeMovieDetailsViewController(movieId: Int, movieTitle: String, coordinator: MoviesCoordinator) -> UIViewController
    func makePosterViewController(imageURL: String) -> UIViewController
    func makeTrailerViewController(videoURL: String) -> UIViewController
}
