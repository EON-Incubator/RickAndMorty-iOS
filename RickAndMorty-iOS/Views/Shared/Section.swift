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
    case characters
    var columnCount: Int {
        switch self {
        case .appearance:
            return 1
        case .info:
            return 3
        case .location:
            return 2
        case .characters:
            return 2
        }
    }
}
