//
//  MoviesFeedViewController.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import UIKit
import Combine

final class MoviesFeedViewController: UIViewController {
    
    private let viewModel: any MoviesFeedViewModelProtocol
    private let coordinator: MoviesCoordinatorProtocol
    private var cancellables: Set<AnyCancellable> = []

    private lazy var tableView = UITableView()

    init(viewModel: any MoviesFeedViewModelProtocol, coordinator: MoviesCoordinatorProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        Task {
            await viewModel.fetchMovies()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Navigation
        self.title = LocalizedKey.moviesSceneTitle.localizedString
        
        // Navigation - right bar button
        let icon = UIImage(systemName: SystemImage.sortIcon.rawValue)?
            .withRenderingMode(.alwaysTemplate)
        
        let rightButton = UIBarButtonItem(
            image: icon,
            style: .plain,
            target: self,
            action: nil
        )
        
        rightButton.tintColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        
        navigationItem.rightBarButtonItem = rightButton
        
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
}

extension MoviesFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let movie = viewModel.currentMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = "Rating: \(movie.rating)"
        return cell
    }
}

extension MoviesFeedViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight * 1.5 {
            guard let lastMovie = viewModel.currentMovies.last else { return }
            viewModel.loadMoreIfNeeded(currentItem: lastMovie)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            navigateToMovieDetails(at: indexPath.row)
        }
        
    private func navigateToMovieDetails(at index: Int) {
        let movie = viewModel.currentMovies[index]
        coordinator.showMovieDetails(with: movie.id)
    }
}
