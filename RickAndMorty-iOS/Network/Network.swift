//
//  Network.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-02-28.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    let apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}
