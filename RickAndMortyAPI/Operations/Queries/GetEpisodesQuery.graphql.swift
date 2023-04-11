// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetEpisodesQuery: GraphQLQuery {
    public static let operationName: String = "getEpisodes"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getEpisodes($page: Int, $name: String, $episode: String) {
          episodes(page: $page, filter: {name: $name, episode: $episode}) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...episodeBasics
              characters {
                __typename
                ...characterBasics
              }
            }
          }
        }
        """#,
        fragments: [PageInfo.self, EpisodeBasics.self, CharacterBasics.self]
      ))

    public var page: GraphQLNullable<Int>
    public var name: GraphQLNullable<String>
    public var episode: GraphQLNullable<String>

    public init(
      page: GraphQLNullable<Int>,
      name: GraphQLNullable<String>,
      episode: GraphQLNullable<String>
    ) {
      self.page = page
      self.name = name
      self.episode = episode
    }

    public var __variables: Variables? { [
      "page": page,
      "name": name,
      "episode": episode
    ] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("episodes", Episodes?.self, arguments: [
          "page": .variable("page"),
          "filter": [
            "name": .variable("name"),
            "episode": .variable("episode")
          ]
        ]),
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
          .field("results", [Result?]?.self),
        ] }

        public var info: Info? { __data["info"] }
        public var results: [Result?]? { __data["results"] }

        /// Episodes.Info
        ///
        /// Parent Type: `Info`
        public struct Info: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Info }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PageInfo.self),
          ] }

          /// The length of the response.
          public var count: Int? { __data["count"] }
          /// The amount of pages.
          public var pages: Int? { __data["pages"] }
          /// Number of the previous page (if it exists)
          public var prev: Int? { __data["prev"] }
          /// Number of the next page (if it exists)
          public var next: Int? { __data["next"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pageInfo: PageInfo { _toFragment() }
          }
        }

        /// Episodes.Result
        ///
        /// Parent Type: `Episode`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Episode }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("characters", [Character?].self),
            .fragment(EpisodeBasics.self),
          ] }

          /// List of characters who have been seen in the episode.
          public var characters: [Character?] { __data["characters"] }
          /// The air date of the episode.
          public var air_date: String? { __data["air_date"] }
          /// The code of the episode.
          public var episode: String? { __data["episode"] }
          /// The id of the episode.
          public var id: RickAndMortyAPI.ID? { __data["id"] }
          /// The name of the episode.
          public var name: String? { __data["name"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var episodeBasics: EpisodeBasics { _toFragment() }
          }

          /// Episodes.Result.Character
          ///
          /// Parent Type: `Character`
          public struct Character: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(CharacterBasics.self),
            ] }

            /// The id of the character.
            public var id: RickAndMortyAPI.ID? { __data["id"] }
            /// The name of the character.
            public var name: String? { __data["name"] }
            /// Link to the character's image.
            /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
            public var image: String? { __data["image"] }
            /// The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
            public var gender: String? { __data["gender"] }
            /// The status of the character ('Alive', 'Dead' or 'unknown').
            public var status: String? { __data["status"] }
            /// The species of the character.
            public var species: String? { __data["species"] }
            /// The type or subspecies of the character.
            public var type: String? { __data["type"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var characterBasics: CharacterBasics { _toFragment() }
            }
          }
        }
      }
    }
  }

}