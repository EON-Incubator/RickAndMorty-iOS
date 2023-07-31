// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetCharactersWithDetailsQuery: GraphQLQuery {
    public static let operationName: String = "getCharactersWithDetails"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getCharactersWithDetails($page: Int) {
          characters(page: $page) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...characterBasics
              episode {
                __typename
                ...episodeBasics
              }
              origin {
                __typename
                ...locationBasics
              }
              location {
                __typename
                ...locationBasics
              }
            }
          }
        }
        """#,
        fragments: [PageInfo.self, CharacterBasics.self, EpisodeBasics.self, LocationBasics.self]
      ))

    public var page: GraphQLNullable<Int>

    public init(page: GraphQLNullable<Int>) {
      self.page = page
    }

    public var __variables: Variables? { ["page": page] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("characters", Characters?.self, arguments: ["page": .variable("page")]),
      ] }

      /// Get the list of all characters
      public var characters: Characters? { __data["characters"] }

      /// Characters
      ///
      /// Parent Type: `Characters`
      public struct Characters: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Characters }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("info", Info?.self),
          .field("results", [Result?]?.self),
        ] }

        public var info: Info? { __data["info"] }
        public var results: [Result?]? { __data["results"] }

        /// Characters.Info
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

        /// Characters.Result
        ///
        /// Parent Type: `Character`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("episode", [Episode?].self),
            .field("origin", Origin?.self),
            .field("location", Location?.self),
            .fragment(CharacterBasics.self),
          ] }

          /// Episodes in which this character appeared.
          public var episode: [Episode?] { __data["episode"] }
          /// The character's origin location
          public var origin: Origin? { __data["origin"] }
          /// The character's last known location
          public var location: Location? { __data["location"] }
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

          /// Characters.Result.Episode
          ///
          /// Parent Type: `Episode`
          public struct Episode: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Episode }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(EpisodeBasics.self),
            ] }

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
          }

          /// Characters.Result.Origin
          ///
          /// Parent Type: `Location`
          public struct Origin: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(LocationBasics.self),
            ] }

            /// The id of the location.
            public var id: RickAndMortyAPI.ID? { __data["id"] }
            /// The dimension in which the location is located.
            public var dimension: String? { __data["dimension"] }
            /// The name of the location.
            public var name: String? { __data["name"] }
            /// The type of the location.
            public var type: String? { __data["type"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var locationBasics: LocationBasics { _toFragment() }
            }
          }

          /// Characters.Result.Location
          ///
          /// Parent Type: `Location`
          public struct Location: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(LocationBasics.self),
            ] }

            /// The id of the location.
            public var id: RickAndMortyAPI.ID? { __data["id"] }
            /// The dimension in which the location is located.
            public var dimension: String? { __data["dimension"] }
            /// The name of the location.
            public var name: String? { __data["name"] }
            /// The type of the location.
            public var type: String? { __data["type"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var locationBasics: LocationBasics { _toFragment() }
            }
          }
        }
      }
    }
  }

}