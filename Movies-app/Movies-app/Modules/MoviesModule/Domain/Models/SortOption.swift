//
//  SortOption.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import UIKit

enum SortOption: Int, CaseIterable {
    case ratingAscending
    case ratingDescending
    case nameAscending
    case nameDescending
    case yearAscending
    case yearDescending
    case votesAscending
    case votesDescending
    case defaultOption

    var title: String {
        switch self {
        case .nameAscending:
            return LocalizedKey.sortByNameAscending.localizedString
        case .nameDescending:
            return LocalizedKey.sortByNameDescending.localizedString
        case .yearAscending:
            return LocalizedKey.sortByYearAscending.localizedString
        case .yearDescending:
            return LocalizedKey.sortByYearDescending.localizedString
        case .ratingAscending:
            return LocalizedKey.sortByRatingAscending.localizedString
        case .ratingDescending:
            return LocalizedKey.sortByRatingDescending.localizedString
        case .votesAscending:
            return LocalizedKey.sortByVotesAscending.localizedString
        case .votesDescending:
            return LocalizedKey.sortByVotesDescending.localizedString
        case .defaultOption:
            return LocalizedKey.sortByDefault.localizedString
        }
    }
}
