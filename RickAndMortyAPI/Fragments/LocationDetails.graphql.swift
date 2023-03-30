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
          image
        }
      }
      """ }

    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
    public static var __selections: [ApolloAPI.Selection] { [
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
      public init(data: DataDict) { __data = data }

      public var locationBasics: LocationBasics { _toFragment() }
    }

    /// Resident
    ///
    /// Parent Type: `Character`
    public struct Resident: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("image", String?.self),
      ] }

      /// Link to the character's image.
      /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
      public var image: String? { __data["image"] }
    }
  }

}