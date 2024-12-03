//
//  MovieDetailsViewController.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit
import Combine

final class MovieDetailsViewController: UIViewController {
    
    // MARK: UI Elements
    
    private lazy var backgroundImageView = UIImageView()
    private lazy var  containerScrollView = UIScrollView()
    private lazy var verticalContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = UIConstants.mediumPadding
        return stackView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.kf.indicatorType = .activity
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.6
        imageView.layer.cornerRadius = UIConstants.cornerRadius
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalCentering
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var movieTrailerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.isUserInteractionEnabled = true
        imageView.image = SystemImage.playButton.image
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var movieTrailerPlaceholder = UIView()
    private lazy var ratingView = RatingView()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 16)
        return label
    }()
    
    private let noPosterLabel = NoPosterLabel()
    
    // MARK: Properties
    
    private let mediumPadding = UIConstants.mediumPadding
    private let bigItemSideSize = UIConstants.bigItemSideSize
    private let lineSeparator = "\n"
    private let posterAspectRatio: CGFloat = 10 / 15
    private let loaderFadeInterval: TimeInterval = 0.3
    
    // Combine
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Dependencies & initialization
    private let viewModel: MovieDetailsViewModelProtocol
    private let coordinator: MoviesCoordinatorProtocol
    
    init(
        viewModel: MovieDetailsViewModelProtocol,
        coordinator: MoviesCoordinatorProtocol
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupLayout()
        setupSelectors()
        setupBindings()
    }
    
    private func setupBindings() {
        
        // Movie details handling
        viewModel.movieDetailsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                setupImages(stringURL: state.movieDetails?.posterImageURLString ?? "")
                showPosterPlaceholder(state.movieDetails?.posterImageURLString == nil)
                setupDetails(with: state.movieDetails)
                updateTrailerImageVisibility(isAvailable: state.trailerURLString != nil)
            }
            .store(in: &cancellables)
    }
    
    private func updateTrailerImageVisibility(isAvailable: Bool) {
        self.movieTrailerImageView.isHidden = !isAvailable
        self.movieTrailerPlaceholder.isHidden = isAvailable
    }
    
    private func setupImages(stringURL: String) {
        let posterImageURL = getImageURL(size: .medium, from: stringURL)
        posterImageView.kf.setImage(with: posterImageURL)
        let backgroundImageURL = getImageURL(size: .original, from: stringURL)
        backgroundImageView.kf.setImage(with: backgroundImageURL)
    }
    
    private func getImageURL(size: ImageSizeQuery, from path: String) -> URL? {
        let correctedPath = path.hasPrefix("/") ? path : "/" + path
        let urlString = APIConstants.baseImageUrl + size.rawValue + correctedPath
        return URL(string: urlString)
    }
    
    private func showPosterPlaceholder(_ show: Bool) {
        noPosterLabel.isHidden = !show
    }
    
    private func setupDetails(with movieDetails: MovieDetails?) {
        guard let movieDetails else { return }
        let countries = movieDetails.countries.joined(separator: lineSeparator)
        countryLabel.text = countries
        titleLabel.text = movieDetails.title
        genresLabel.text = movieDetails.genres.map { $0.name }.joined(separator: lineSeparator)
        ratingView.configure(withRating: movieDetails.rating, votes: movieDetails.votes)
        descriptionLabel.text = movieDetails.overview
    }
    
    // MARK: Actions & Selectors
    
    @objc private func trailerButtonDidTap() {
        guard let trailerUrlString = viewModel.state.trailerURLString else { return }
        coordinator.showTrailerVideo(trailerUrlString)
    }
    
    @objc private func didTapPosterImageView() {
        guard let posterImageURLString = viewModel.state.movieDetails?.posterImageURLString else { return }
        coordinator.showPosterImage(posterImageURLString)
    }
    
    @objc private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupSelectors() {
        let posterTap = UITapGestureRecognizer(target: self, action: #selector(didTapPosterImageView))
        posterImageView.addGestureRecognizer(posterTap)
        let trailerTap = UITapGestureRecognizer(target: self, action: #selector(trailerButtonDidTap))
        movieTrailerImageView.addGestureRecognizer(trailerTap)
    }
}

// MARK: UI Configurations

extension MovieDetailsViewController {
    
    private func setupNavigationBar() {
        title = viewModel.state.movieTitle
        let icon = SystemImage.backButton.image
        let item = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(didTapBackButton))
        item.tintColor = UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        navigationItem.leftBarButtonItem = item
    }
    
    private func setupLayout() {
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.fillSuperviewSafeArea()
        backgroundImageView.applyBlurEffect()
        view.addSubview(containerScrollView)
        containerScrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        containerScrollView.addSubview(verticalContainerStackView)
        verticalContainerStackView.anchor(
            top: containerScrollView.topAnchor,
            left: containerScrollView.leftAnchor,
            bottom: containerScrollView.bottomAnchor,
            right: containerScrollView.rightAnchor,
            paddingLeft: mediumPadding,
            paddingRight: mediumPadding
        )
        verticalContainerStackView.setWidth(view.frame.width - mediumPadding * 2)
        verticalContainerStackView.addArrangedSubview(posterImageView)
        posterImageView.addSubview(noPosterLabel)
        noPosterLabel.fillSuperview()
        posterImageView.setDimensions(height: view.frame.width, width: view.frame.width * posterAspectRatio)
        verticalContainerStackView.addArrangedSubview(titleLabel)
        verticalContainerStackView.addArrangedSubview(countryLabel)
        verticalContainerStackView.addArrangedSubview(horizontalStackView)
        verticalContainerStackView.addArrangedSubview(descriptionLabel)
        setupHorizontalStackLayout()
    }
    
    private func setupHorizontalStackLayout() {
        horizontalStackView.setWidth(view.frame.width - mediumPadding * 2)
        horizontalStackView.addArrangedSubview(movieTrailerImageView)
        movieTrailerImageView.setDimensions(height: bigItemSideSize, width: bigItemSideSize)
        movieTrailerImageView.layer.cornerRadius = bigItemSideSize / 2
        horizontalStackView.addArrangedSubview(movieTrailerPlaceholder)
        movieTrailerPlaceholder.setDimensions(height: bigItemSideSize, width: bigItemSideSize)
        horizontalStackView.addArrangedSubview(genresLabel)
        horizontalStackView.addArrangedSubview(ratingView)
        ratingView.setDimensions(height: bigItemSideSize, width: bigItemSideSize)
    }
}
