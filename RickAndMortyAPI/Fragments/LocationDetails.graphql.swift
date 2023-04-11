// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  struct LocationDetails: RickAndMortyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString { """
      fragment locationDetails on Location {
        __typename
        ...locationBasics
        residents {
          __typename
          ...characterBasics
        }
      }
      """ }

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

    /// Resident
    ///
    /// Parent Type: `Character`
    public struct Resident: RickAndMortyAPI.SelectionSet {
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