//
//  LocalizedKey.swift
//  Movies-app
//
//  Created by Oleh on 29.11.2024.
//

import Foundation

enum LocalizedKey: String {
    
    // MARK: Movies scene
    case moviesSceneTitle
    case searchPlaceholder
    case noResultsLabel
    case pullToRefresh
    case sortOptionsTitle
    case noPosterLabel

    // MARK: Sort options
    case sortByDefault
    case sortByRatingDescending
    case sortByNameAscending
    case sortByYearDescending
    case sortByVotesDescending
    case sortOptionsCancelButton

    // MARK: Errors
    case errorTitle
    case errorOkButton
    case networkErrorNoConnection
    case networkErrorNoData
    case networkErrorRequestFailed
    case networkErrorInvalidData
    case networkErrorInvalidURL
    case networkErrorUnauthorized
    case networkErrorDecodingFailed

    // MARK: Trailer scene
    case trailerSceneTitle

    // MARK: Poster scene
    case posterSceneTitle
    
    // MARK: Searching
    case searching

    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
