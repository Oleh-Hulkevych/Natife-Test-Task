//
//  MoviesEmptyStateLabel.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

import UIKit

final class MoviesEmptyStateLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabel() {
        text = LocalizedKey.noResultsLabel.localizedString
        textAlignment = .center
        font = .boldSystemFont(ofSize: 20)
        textColor = .systemGray
        isHidden = true
    }
}
