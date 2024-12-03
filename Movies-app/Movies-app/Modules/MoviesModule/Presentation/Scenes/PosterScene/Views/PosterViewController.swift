//
//  PosterViewController.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit
import Kingfisher

final class PosterViewController: UIViewController {
    
    // MARK: UI Elements

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.isOpaque = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    // MARK: Properties

    private let imageURL: String

    // MARK: Initialization

    init(imageURL: String) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupScrollView()
        setupPosterImageView()
    }
    
    // MARK: Actions
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UI Setup
    
    private func setupUI() {
        title = LocalizedKey.posterSceneTitle.localizedString
        view.backgroundColor = .black
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        closeButton.tintColor = .white
        navigationItem.rightBarButtonItem = closeButton
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        scrollView.addSubview(posterImageView)
        posterImageView.center(inView: scrollView)
        let layoutFrame = scrollView.frameLayoutGuide.layoutFrame
        posterImageView.setDimensions(height: layoutFrame.height, width: layoutFrame.width)
        scrollView.delegate = self
    }

    private func setupPosterImageView() {
        let url = getImageURL(size: .original, from: imageURL)
        posterImageView.kf.setImage(with: url)
    }
    
    func getImageURL(size: ImageSizeQuery, from path: String) -> URL? {
        let correctedPath = path.hasPrefix("/") ? path : "/" + path
        let urlString = APIConstants.baseImageUrl + size.rawValue + correctedPath
        return URL(string: urlString)
    }
}

// MARK: - UIScrollView Delegate

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        posterImageView
    }
}
