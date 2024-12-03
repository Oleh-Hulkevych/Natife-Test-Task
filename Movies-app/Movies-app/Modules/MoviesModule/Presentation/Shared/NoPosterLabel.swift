//
//  NoPosterLabel.swift
//  Movies-app
//
//  Created by Oleh on 01.12.2024.
//

import UIKit

final class NoPosterLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
    }

    private func configureLabel() {
        isHidden = true
        self.text = LocalizedKey.noPosterLabel.localizedString
        self.textColor = .white
        self.backgroundColor = .black
        self.numberOfLines = 0
        self.textAlignment = .center
        self.layer.cornerRadius = UIConstants.cornerRadius
        self.clipsToBounds = true
        self.font = .boldSystemFont(ofSize: 20)
    }
}
