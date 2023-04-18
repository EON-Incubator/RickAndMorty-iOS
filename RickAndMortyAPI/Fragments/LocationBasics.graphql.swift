// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  struct LocationBasics: RickAndMortyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString { """
      fragment locationBasics on Location {
        __typename
        id
        dimension
        name
        type
      }
      """ }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", RickAndMortyAPI.ID?.self),
      .field("dimension", String?.self),
      .field("name", String?.self),
      .field("type", String?.self),
    ] }

    /// The id of the location.
    public var id: RickAndMortyAPI.ID? { __data["id"] }
    /// The dimension in which the location is located.
    public var dimension: String? { __data["dimension"] }
    /// The name of the location.
    public var name: String? { __data["name"] }
    /// The type of the location.
    public var type: String? { __data["type"] }
  }

}