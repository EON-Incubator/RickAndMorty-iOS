// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetEpisodesCountQuery: GraphQLQuery {
    public static let operationName: String = "getEpisodesCount"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getEpisodesCount {
          episodes {
            __typename
            info {
              __typename
              count
            }
          }
        }
        """#
      ))

    public init() {}

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("episodes", Episodes?.self),
      ] }

      /// Get the list of all episodes
      public var episodes: Episodes? { __data["episodes"] }

      /// Episodes
      ///
      /// Parent Type: `Episodes`
      public struct Episodes: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Episodes }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("info", Info?.self),
        ] }

        public var info: Info? { __data["info"] }

        /// Episodes.Info
        ///
        /// Parent Type: `Info`
        public struct Info: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Info }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("count", Int?.self),
          ] }

          /// The length of the response.
          public var count: Int? { __data["count"] }
        }
      }
    }
  }

}