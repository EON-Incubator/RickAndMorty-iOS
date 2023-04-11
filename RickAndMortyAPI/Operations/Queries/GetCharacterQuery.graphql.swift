// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetCharacterQuery: GraphQLQuery {
    public static let operationName: String = "getCharacter"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getCharacter($characterId: ID!) {
          character(id: $characterId) {
            __typename
            ...characterBasics
            created
            episode {
              __typename
              ...episodeBasics
              characters {
                __typename
                image
              }
            }
            origin {
              __typename
              ...locationBasics
            }
            location {
              __typename
              ...locationBasics
              residents {
                __typename
                image
              }
            }
          }
        }
        """#,
        fragments: [CharacterBasics.self, EpisodeBasics.self, LocationBasics.self]
      ))

    public var characterId: ID

    public init(characterId: ID) {
      self.characterId = characterId
    }

    public var __variables: Variables? { ["characterId": characterId] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("character", Character?.self, arguments: ["id": .variable("characterId")]),
      ] }

      /// Get a specific character by ID
      public var character: Character? { __data["character"] }

      /// Character
      ///
      /// Parent Type: `Character`
      public struct Character: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("created", String?.self),
          .field("episode", [Episode?].self),
          .field("origin", Origin?.self),
          .field("location", Location?.self),
          .fragment(CharacterBasics.self),
        ] }

        /// Time at which the character was created in the database.
        public var created: String? { __data["created"] }
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

        /// Character.Episode
        ///
        /// Parent Type: `Episode`
        public struct Episode: RickAndMortyAPI.SelectionSet {
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

          /// Character.Episode.Character
          ///
          /// Parent Type: `Character`
          public struct Character: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("image", String?.self),
            ] }

            /// Link to the character's image.
            /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
            public var image: String? { __data["image"] }
          }
        }

        /// Character.Origin
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

        /// Character.Location
        ///
        /// Parent Type: `Location`
        public struct Location: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("residents", [Resident?].self),
            .fragment(LocationBasics.self),
          ] }

          /// List of characters who have been last seen in the location.
          public var residents: [Resident?] { __data["residents"] }
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

          /// Character.Location.Resident
          ///
          /// Parent Type: `Character`
          public struct Resident: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("image", String?.self),
            ] }

            /// Link to the character's image.
            /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
            public var image: String? { __data["image"] }
          }
        }
      }
    }
  }

}