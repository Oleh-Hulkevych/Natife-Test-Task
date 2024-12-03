//
//  MoviesTableView.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

import UIKit

protocol MoviesTableViewDelegate: AnyObject {
    func refreshTriggered()
    func calculateRowHeight() -> CGFloat
}

final class MoviesTableView: UITableView {
    
    // MARK: Properties
    
    private weak var moviesDelegate: MoviesTableViewDelegate?
    
    // MARK: Initialization
    
    init(delegate: (MoviesTableViewDelegate & UITableViewDelegate & UITableViewDataSource)) {
        self.moviesDelegate = delegate
        super.init(frame: .zero, style: .plain)
        configureTableView(delegate: delegate)
        setupRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configureTableView(delegate: UITableViewDelegate & UITableViewDataSource) {
        register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        separatorStyle = .none
        keyboardDismissMode = .onDrag
        self.delegate = delegate
        self.dataSource = delegate
        rowHeight = moviesDelegate?.calculateRowHeight() ?? 0
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(
            string: LocalizedKey.pullToRefresh.localizedString
        )
        refreshControl.addTarget(
            self,
            action: #selector(refreshPulled),
            for: .valueChanged
        )
        self.refreshControl = refreshControl
    }
    
    @objc private func refreshPulled() {
        moviesDelegate?.refreshTriggered()
    }
}
