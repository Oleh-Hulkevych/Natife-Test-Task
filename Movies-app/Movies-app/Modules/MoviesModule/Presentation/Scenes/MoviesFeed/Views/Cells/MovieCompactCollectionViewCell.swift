//
//  MovieCompactCollectionViewCell.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

import UIKit
import Kingfisher

final class MovieCompactCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.cornerRadius
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.4
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.cornerRadius
        return imageView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0, 0.3, 0.7, 1]
        return layer
    }()
    
    private lazy var noPosterLabel = NoPosterLabel()
    
    // MARK: Properties
    
    static let reuseIdentifier = String(describing: MovieCompactCollectionViewCell.self)
    private let smallPadding = UIConstants.smallPadding
    private let mediumPadding = UIConstants.mediumPadding
    private let bigItemSideSize = UIConstants.bigItemSideSize
    private let loaderFadeInterval: TimeInterval = 0.3

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupImageView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        gradientLayer.frame = posterImageView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        noPosterLabel.isHidden = true
    }
    
    func configure(with movie: Movie) {
        setImage(from: movie)
    }
    
    private func setImage(from movie: Movie) {
        let posterImageURL = movie.getImageURL(type: .poster, size: .medium)
        let backdropImageURL = movie.getImageURL(type: .backdrop, size: .small)
        let url = backdropImageURL ?? posterImageURL
        posterImageView.kf.setImage(
            with: url, options: [.transition(.fade(loaderFadeInterval))]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.noPosterLabel.isHidden = true
            case .failure:
                self.noPosterLabel.isHidden = false
            }
        }
    }
    
    // MARK: UI Setup
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            paddingTop: smallPadding,
            paddingLeft: mediumPadding,
            paddingBottom: smallPadding,
            paddingRight: mediumPadding
        )
    }
    
    private func setupImageView() {
        containerView.addSubview(posterImageView)
        posterImageView.fillSuperview()
        posterImageView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = posterImageView.bounds
        posterImageView.addSubview(noPosterLabel)
        noPosterLabel.fillSuperview()
    }
}
