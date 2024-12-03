//
//  MoviesSearchBar.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

import UIKit

final class MoviesSearchBar: UISearchBar {
    
    // MARK: Initialization
    
    init(delegate: UISearchBarDelegate) {
        super.init(frame: .zero)
        configureSearchBar(delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configureSearchBar(delegate: UISearchBarDelegate) {
        backgroundColor = .systemBackground
        placeholder = LocalizedKey.searchPlaceholder.localizedString
        searchBarStyle = .default
        configureTextInput()
        self.delegate = delegate
    }
    
    private func configureTextInput() {
        textContentType = .none
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        smartQuotesType = .no
    }
}
