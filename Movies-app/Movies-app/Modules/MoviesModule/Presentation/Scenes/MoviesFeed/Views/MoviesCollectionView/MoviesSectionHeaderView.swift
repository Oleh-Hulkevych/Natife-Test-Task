//
//  MoviesSectionHeaderView.swift
//  Movies-app
//
//  Created by Oleh on 06.12.2024.
//

import UIKit

final class MoviesSectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = String(describing: MoviesSectionHeaderView.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        titleLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: UIConstants.smallPadding,
            paddingLeft: UIConstants.mediumPadding
        )
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
