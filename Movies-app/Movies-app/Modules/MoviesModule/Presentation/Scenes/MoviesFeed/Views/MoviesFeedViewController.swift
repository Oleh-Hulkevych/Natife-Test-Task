//
//  MoviesFeedViewController.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import UIKit
import Combine

final class MoviesFeedViewController: UIViewController {
    
    // MARK: UI Elements
    private lazy var sortButton = MoviesSortBarButtonItem(delegate: self)
    private lazy var searchBar = MoviesSearchBar(delegate: self)
    private lazy var emptyStateLabel = MoviesEmptyStateLabel()
    private lazy var collectionView = MoviesCollectionView(delegate: self)
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Dependencies & initialization
    private let viewModel: MoviesFeedViewModelProtocol
    private let coordinator: MoviesCoordinatorProtocol
    
    init(viewModel: MoviesFeedViewModelProtocol, coordinator: MoviesCoordinatorProtocol) {
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
        setupUI()
        setupLayout()
        setupBindings()
    }
    
    // MARK: Bindings
    
    private func setupBindings() {
        
        // Empty state handling
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .map(\.movies)
            .sink { [weak self] movies in
                guard let self else { return }
                self.handleEmptyState(for: movies)
            }
            .store(in: &cancellables)
        
        // Error state handling
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0.error }
            .sink { [weak self] error in
                guard let self else { return }
                if case .noConnection = error {
                    return
                }
                self.showError(error)
            }
            .store(in: &cancellables)
        
        
        // Loading state handling
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .map(\.loading)
            .removeDuplicates()
            .sink { [weak self] loadingState in
                guard let self else { return }
                self.showSearchLoading(for: loadingState)
            }
            .store(in: &cancellables)
        
        // User flow state handling
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .map(\.userFlow)
            .removeDuplicates()
            .sink { [weak self] state in
                guard let self else { return }
                self.updateSortButtonState(for: state)
            }
            .store(in: &cancellables)
    }
    
    private func handleEmptyState(for movies: [Movie]) {
        emptyStateLabel.isHidden = !movies.isEmpty
        collectionView.reloadData()
    }
    
    private func showError(_ error: NetworkError) {
        coordinator.showAlert(
            from: self,
            title: LocalizedKey.errorTitle.localizedString,
            message: error.errorDescription,
            buttonTitle: LocalizedKey.errorOkButton.localizedString
        )
    }
    
    private func showSearchLoading(for loadingState: MoviesLoadingState) {
        if case .searching = loadingState {
            navigationItem.titleView = SearchLoadingView()
        } else {
            navigationItem.titleView = nil
            title = LocalizedKey.moviesSceneTitle.localizedString
        }
    }
    
    private func updateSortButtonState(for state: MoviesFeedUserFlow) {
        if case .searching = state {
            sortButton.updateAppearance(isEnabled: false)
        } else {
            sortButton.updateAppearance(isEnabled: true)
        }
    }
}

// MARK: - Collection view delegates & data source

extension MoviesFeedViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        MoviesSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = MoviesSection(rawValue: section) else { return 0 }
        switch section {
            // I didn’t get creative here and used only the data we already have.
        case .parallax: return viewModel.state.movies.count
        case .carousel: return viewModel.state.movies.count
        case .grouped: return viewModel.state.movies.count
        case .horizontalFeed: return viewModel.state.movies.count
        case .verticalFeed: return viewModel.state.movies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = MoviesSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.state.movies[indexPath.item]
        return section.dequeueCell(in: collectionView, at: indexPath, with: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MoviesSectionHeaderView.reuseIdentifier,
                for: indexPath
            ) as? MoviesSectionHeaderView else {
                return UICollectionReusableView()
            }
            
            if viewModel.state.isNetworkConnected {
                let section = MoviesSection(rawValue: indexPath.section) ?? .parallax
                header.configure(with: section.title)
            } else {
                header.configure(with: "")
            }
            
            return header
        }
        return UICollectionReusableView()
    }
}

extension MoviesFeedViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard viewModel.state.userFlow == .browsing else { return }
        guard viewModel.state.isNetworkConnected else { return }
        let maxItem = indexPaths.map { $0.item }.max() ?? 0
        if maxItem > viewModel.state.movies.count - 5 {
            viewModel.loadMorePopularMovies()
        }
    }
}

extension MoviesFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToMovieDetails(at: indexPath.item)
    }
    
    private func navigateToMovieDetails(at index: Int) {
        let movie = viewModel.state.movies[index]
        if viewModel.state.isNetworkConnected {
            coordinator.showMovieDetails(with: movie.id, title: movie.title)
        } else {
            showError(.noConnection)
        }
    }
}

extension MoviesFeedViewController: MoviesCollectionViewDelegate {
    
    func refreshTriggered() {
        viewModel.switchUserFlow(to: .browsing)
        resetSearchBar()
        viewModel.refreshMovies()
        collectionView.refreshControl?.endRefreshing()
    }
    
    private func resetSearchBar() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - Search bar delegates

extension MoviesFeedViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.switchUserFlow(to: .searching)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchMovies(query: query)
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.switchUserFlow(to: .browsing)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.refreshMovies()
        searchBar.setShowsCancelButton(false, animated: true)
        collectionView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - Sort button delegate

extension MoviesFeedViewController: MoviesSortBarButtonDelegate {
    
    func sortButtonTapped() {
        if viewModel.state.isNetworkConnected {
            showSortActionSheet()
        } else {
            showError(NetworkError.noConnection)
        }
    }
    
    private func showSortActionSheet() {
        coordinator.showSortActionSheet(
            from: self,
            currentOption: viewModel.state.sortOption,
            sourceButton: sortButton
        ) { [weak self] option in
            guard let self else { return }
            self.viewModel.applySorting(option)
            collectionView.setContentOffset(.zero, animated: true)
        }
    }
}

// MARK: - UI Setup

extension MoviesFeedViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = LocalizedKey.moviesSceneTitle.localizedString
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupLayout() {
        
        view.addSubview(searchBar)
        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
        
        view.addSubview(collectionView)
        collectionView.anchor(
            top: searchBar.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        collectionView.addSubview(emptyStateLabel)
        emptyStateLabel.center(inView: collectionView)
    }
}
