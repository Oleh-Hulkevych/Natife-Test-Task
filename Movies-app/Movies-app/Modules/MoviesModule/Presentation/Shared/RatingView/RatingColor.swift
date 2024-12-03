//
//  RatingColor.swift
//  Movies-app
//
//  Created by Oleh on 02.12.2024.
//

import UIKit

enum RatingColor {
    
    case low
    case belowMedium
    case medium
    case high
    
    init(rating: CGFloat) {
        switch rating {
        case 0.0..<2.5:
            self = .low
        case 2.5..<5.0:
            self = .belowMedium
        case 5.0..<7.5:
            self = .medium
        case 7.5...10.0:
            self = .high
        default:
            self = .low
        }
    }
    
    var color: UIColor {
        switch self {
        case .low:
            return .systemRed
        case .belowMedium:
            return .systemOrange
        case .medium:
            return .systemYellow
        case .high:
            return .systemGreen
        }
    }
}
