//
//  SearchLoadingView.swift
//  Movies-app
//
//  Created by Oleh on 03.12.2024.
//

import UIKit

final class SearchLoadingView: UIStackView {
    
    // MARK: UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedKey.searching.localizedString
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        return indicator
    }()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupUI() {
        spacing = 8
        alignment = .center
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(activityIndicator)
    }
}
