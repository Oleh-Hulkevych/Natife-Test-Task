//
//  MovieTableViewCell.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    
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
    
    private lazy var topHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        return stackView
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let ratingView = RatingView()
    
    // MARK: Properties
    
    static let reuseIdentifier = String(describing: MovieTableViewCell.self)
    private let smallPadding = UIConstants.smallPadding
    private let mediumPadding = UIConstants.mediumPadding
    private let bigItemSideSize = UIConstants.bigItemSideSize
    private let loaderFadeInterval: TimeInterval = 0.3
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContainerView()
        setupImageView()
        setupTopElements()
        setupBottomElements()
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
        titleLabel.text = nil
        yearLabel.text = nil
        genresLabel.text = nil
        noPosterLabel.isHidden = true
        ratingView.configure(withRating: 0, votes: 0)
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: UIConstants.pointSeparator)
        ratingView.configure(withRating: movie.rating, votes: movie.votes)
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
    
    private func setupTopElements() {
        containerView.addSubview(topHorizontalStackView)
        topHorizontalStackView.anchor(
            top: containerView.topAnchor,
            left: containerView.leftAnchor,
            right: containerView.rightAnchor,
            paddingTop: mediumPadding,
            paddingLeft: mediumPadding,
            paddingRight: mediumPadding
        )
        topHorizontalStackView.addArrangedSubview(titleLabel)
        topHorizontalStackView.addArrangedSubview(yearLabel)
    }
    
    private func setupBottomElements() {
        containerView.addSubview(bottomHorizontalStackView)
        bottomHorizontalStackView.anchor(
            left: containerView.leftAnchor,
            bottom: containerView.bottomAnchor,
            right: containerView.rightAnchor,
            paddingLeft: mediumPadding,
            paddingBottom: mediumPadding,
            paddingRight: mediumPadding
        )
        bottomHorizontalStackView.addArrangedSubview(genresLabel)
        bottomHorizontalStackView.addArrangedSubview(ratingView)
        ratingView.setDimensions(height: bigItemSideSize, width: bigItemSideSize)
    }
}
