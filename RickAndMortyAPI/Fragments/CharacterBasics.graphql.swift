// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  struct CharacterBasics: RickAndMortyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString { """
      fragment characterBasics on Character {
        __typename
        id
        name
        image
        gender
        status
        species
        type
      }
      """ }

    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("id", RickAndMortyAPI.ID?.self),
      .field("name", String?.self),
      .field("image", String?.self),
      .field("gender", String?.self),
      .field("status", String?.self),
      .field("species", String?.self),
      .field("type", String?.self),
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
  }

}