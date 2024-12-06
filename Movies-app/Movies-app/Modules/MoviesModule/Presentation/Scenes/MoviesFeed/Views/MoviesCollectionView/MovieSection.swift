//
//  MovieSection.swift
//  Movies-app
//
//  Created by Oleh on 06.12.2024.
//

import UIKit

enum MoviesSection: Int, CaseIterable {
    
    case parallax
    case carousel
    case grouped
    case horizontalFeed
    case verticalFeed
    
    // I didn't add the strings to the localized file.
    // I created a switch for the header titles for better clarity.
    var title: String { // TODO: Add a key to the localized strings if needed.
        switch self {
        case .parallax:
            return "Parallax effect"
        case .carousel:
            return "Carousel"
        case .grouped:
            return "Grouped"
        case .horizontalFeed:
            return "Horizontal"
        case .verticalFeed:
            return "Vertical"
        }
    }
    
    private var cellType: UICollectionViewCell.Type {
        switch self {
        case .parallax, .carousel, .verticalFeed:
            return MovieLargeCollectionViewCell.self
        case .grouped, .horizontalFeed:
            return MovieCompactCollectionViewCell.self
        }
    }
    
    func dequeueCell(
        in collectionView: UICollectionView,
        at indexPath: IndexPath,
        with movie: Movie
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: cellType),
            for: indexPath
        )
        
        switch cell {
        case let largeCell as MovieLargeCollectionViewCell:
            largeCell.configure(with: movie)
            return largeCell
        case let compactCell as MovieCompactCollectionViewCell:
            compactCell.configure(with: movie)
            return compactCell
        default:
            return UICollectionViewCell()
        }
    }
}
