//
//  MoviesCollectionView.swift
//  Movies-app
//
//  Created by Oleh on 06.12.2024.
//

import UIKit

protocol MoviesCollectionViewDelegate: AnyObject {
    func refreshTriggered()
}

final class MoviesCollectionView: UICollectionView {
    
    // MARK: Properties
    private weak var moviesDelegate: MoviesCollectionViewDelegate?
    
    // MARK: Initialization
    init(delegate: (MoviesCollectionViewDelegate & UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDataSourcePrefetching)) {
        self.moviesDelegate = delegate
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.collectionViewLayout = createLayout()
        configureCollectionView(delegate: delegate)
        setupRefreshControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    private func configureCollectionView(delegate: UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDataSourcePrefetching) {
        backgroundColor = .systemBackground
        self.delegate = delegate
        self.dataSource = delegate
        self.prefetchDataSource = delegate
        keyboardDismissMode = .onDrag
        register(MovieLargeCollectionViewCell.self, forCellWithReuseIdentifier: MovieLargeCollectionViewCell.reuseIdentifier)
        register(MovieCompactCollectionViewCell.self, forCellWithReuseIdentifier: MovieCompactCollectionViewCell.reuseIdentifier)
        register(
            MoviesSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MoviesSectionHeaderView.reuseIdentifier
        )
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

//MARK: - Layout

extension MoviesCollectionView {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection in
            guard let self else {
                return NSCollectionLayoutSection(
                    group: NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(1.0)
                        ),
                        subitems: []
                    )
                )
            }
            
            let section = MoviesSection(rawValue: sectionIndex) ?? .verticalFeed
            
            return switch section {
            case .parallax: createParallaxSectionView()
            case .carousel: createCarouselSectionView()
            case .grouped: createGroupedSectionView()
            case .horizontalFeed: createHorizontalFeedSectionView()
            case .verticalFeed: createVerticalFeedSectionFeedView()
            }
        }
        
        return layout
    }
    
    private func calculateRowHeight() -> CGFloat {
        let safeAreaHeight = UIScreen.main.bounds.height
        return safeAreaHeight / 3
    }
    
    private func createParallaxSectionView() -> NSCollectionLayoutSection {
        
        let rowHeight = calculateRowHeight()
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        // Header
        let sectionHeader = setupHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        // Parallax effect
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            let centerX = offset.x + environment.container.contentSize.width / 2
            items.forEach { item in
                guard item.representedElementKind != UICollectionView.elementKindSectionHeader else { return }
                let distanceFromCenter = abs(item.frame.midX - centerX)
                let maxDistance = environment.container.contentSize.width / 2
                let scale = max(0.6, 1 - (distanceFromCenter / maxDistance) * 0.4)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                    .concatenating(CGAffineTransform(translationX: 0, y: distanceFromCenter * 0.1))
                item.alpha = scale
            }
        }
        
        return section
    }
    
    private func createCarouselSectionView() -> NSCollectionLayoutSection {
        
        let sideInset: CGFloat = 50
        let initialRowHeight = calculateRowHeight()
        let parallaxHeight = initialRowHeight - sideInset 
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(UIScreen.main.bounds.width - (sideInset * 2)),
            heightDimension: .absolute(parallaxHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: sideInset,
            bottom: 0,
            trailing: sideInset
        )
        
        // Header
        let sectionHeader = setupHeader(absoluteOffset: CGPoint(x: -sideInset, y: 0))
        section.boundarySupplementaryItems = [sectionHeader]
        
        // Carousel effect
        section.visibleItemsInvalidationHandler = { items, offset, environment in
            let currentPage = round(offset.x / environment.container.contentSize.width)
            let isFirstPage = currentPage == 0
            
            items.forEach { item in
                if item.representedElementKind != UICollectionView.elementKindSectionHeader {
                    item.transform = isFirstPage ? CGAffineTransform(translationX: -sideInset, y: 0) : .identity
                }
            }
        }
        
        return section
    }
    
    private func createGroupedSectionView() -> NSCollectionLayoutSection {
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Horizontal group with two items
        let horizontalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: horizontalGroupSize,
            subitems: [item, item]
        )
        
        // Main group with two horizontal subgroups
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [horizontalGroup, horizontalGroup]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 0
        
        // Header
        let sectionHeader = setupHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createHorizontalFeedSectionView() -> NSCollectionLayoutSection {
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 0
        
        // Header
        let sectionHeader = setupHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createVerticalFeedSectionFeedView() -> NSCollectionLayoutSection {
        
        let rowHeight = calculateRowHeight()
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(rowHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        
        // Header
        let sectionHeader = setupHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // MARK: Headers & footers
    
    private func setupHeader(absoluteOffset: CGPoint? = .zero) -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .absolute(40)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top,
            absoluteOffset: absoluteOffset ?? .zero
        )
        
        return sectionHeader
    }
}
