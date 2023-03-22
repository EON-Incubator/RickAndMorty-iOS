//
//  Sections.swift
//  RickAndMorty-iOS
//
//  Created by Gagan on 2023-03-13.
//

import Foundation

enum Section: Int, CaseIterable {
    case appearance
    case info
    case location
    case episodes
    case empty
    var columnCount: Int {
        switch self {
        case .appearance:
            return 1
        case .info:
            return 3
        case .location:
            return 1
        case .episodes:
            return 2
        case .empty:
            return 2
        }

    }
}
