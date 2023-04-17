// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetEpisodeQuery: GraphQLQuery {
    public static let operationName: String = "getEpisode"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getEpisode($episodeId: ID!) {
          episode(id: $episodeId) {
            __typename
            ...episodeBasics
            created
            characters {
              __typename
              ...characterBasics
            }
          }
        }
        """#,
        fragments: [EpisodeBasics.self, CharacterBasics.self]
      ))

    public var episodeId: ID

    public init(episodeId: ID) {
      self.episodeId = episodeId
    }

    public var __variables: Variables? { ["episodeId": episodeId] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("episode", Episode?.self, arguments: ["id": .variable("episodeId")]),
      ] }

      /// Get a specific episode by ID
      public var episode: Episode? { __data["episode"] }

      /// Episode
      ///
      /// Parent Type: `Episode`
      public struct Episode: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Episode }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("created", String?.self),
          .field("characters", [Character?].self),
          .fragment(EpisodeBasics.self),
        ] }

        /// Time at which the episode was created in the database.
        public var created: String? { __data["created"] }
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

        /// Episode.Character
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