//
//  SystemImage.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

enum SystemImage: String {
    
    case sortIcon = "arrow.up.and.down.text.horizontal"
    case sortAscending = "arrow.up"
    case sortDescending = "arrow.down"
    case backButton = "chevron.left"
    case playButton = "play.circle.fill"

    var image: UIImage? { UIImage(systemName: rawValue) }
}
