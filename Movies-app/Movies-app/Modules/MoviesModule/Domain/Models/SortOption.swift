//
//  SortOption.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

enum SortOption: Int, CaseIterable {

    case ratingDescending
    case nameAscending
    case votesDescending
    case defaultOption

    var title: String {
        switch self {
        case .nameAscending:
            return LocalizedKey.sortByNameAscending.localizedString
        case .ratingDescending:
            return LocalizedKey.sortByRatingDescending.localizedString
        case .votesDescending:
            return LocalizedKey.sortByVotesDescending.localizedString
        case .defaultOption:
            return LocalizedKey.sortByDefault.localizedString
        }
    }
}
