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
    private lazy var tableView = MoviesTableView(delegate: self)
    private lazy var emptyStateLabel = MoviesEmptyStateLabel()
    
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
        tableView.reloadData()
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

// MARK: - Table view delegates & data source

extension MoviesFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            indexPath.row < viewModel.state.movies.count,
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieTableViewCell.reuseIdentifier
            ) as? MovieTableViewCell
        else {
            return UITableViewCell()
        }
        
        let movie = viewModel.state.movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
}

extension MoviesFeedViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.state.userFlow == .browsing else { return }
        guard viewModel.state.isNetworkConnected else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight * 1.5 {
            viewModel.loadMorePopularMovies()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToMovieDetails(at: indexPath.row)
    }
    
    private func navigateToMovieDetails(at index: Int) {
        let movie = viewModel.state.movies[index]
        if viewModel.state.isNetworkConnected {
            coordinator.showMovieDetails(with: movie.id)
        } else {
            showError(.noConnection)
        }
    }
}

extension MoviesFeedViewController: MoviesTableViewDelegate {
    
    func refreshTriggered() {
        viewModel.switchUserFlow(to: .browsing)
        resetSearchBar()
        viewModel.refreshMovies()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func resetSearchBar() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func calculateRowHeight() -> CGFloat {
        return view.safeAreaLayoutGuide.layoutFrame.height * 1 / 3
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
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.switchUserFlow(to: .browsing)
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.refreshMovies()
        searchBar.setShowsCancelButton(false, animated: true)
        tableView.setContentOffset(.zero, animated: true)
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
            self.tableView.setContentOffset(.zero, animated: true)
        }
    }
}

// MARK: - UI Configurations

private extension MoviesFeedViewController {
    
    private func setupUI() {
        // Controller
        view.backgroundColor = .systemBackground
        title = LocalizedKey.moviesSceneTitle.localizedString
        // Navigation items
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupLayout() {
        
        view.addSubview(searchBar)
        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor
        )
        
        view.addSubview(tableView)
        tableView.anchor(
            top: searchBar.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        
        tableView.addSubview(emptyStateLabel)
        emptyStateLabel.center(inView: tableView)
    }
}
