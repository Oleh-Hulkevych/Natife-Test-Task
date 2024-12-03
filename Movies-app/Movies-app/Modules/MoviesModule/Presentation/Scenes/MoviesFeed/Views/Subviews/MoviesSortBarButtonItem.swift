//
//  MoviesSortBarButtonItem.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

import UIKit

protocol MoviesSortBarButtonDelegate: AnyObject {
    func sortButtonTapped()
}

final class MoviesSortBarButtonItem: UIBarButtonItem {

    private weak var delegate: MoviesSortBarButtonDelegate?

    init(delegate: MoviesSortBarButtonDelegate) {
        self.delegate = delegate
        super.init()
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        image = UIImage(systemName: SystemImage.sortIcon.rawValue)
        style = .plain
        target = self
        action = #selector(handleTap)
        updateAppearance(isEnabled: true)
    }

    func updateAppearance(isEnabled: Bool) {
        self.isEnabled = isEnabled
        tintColor = isEnabled ? UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? .white : .black
        } : .gray
    }

    @objc private func handleTap() {
        guard isEnabled else { return }
        delegate?.sortButtonTapped()
    }
}
