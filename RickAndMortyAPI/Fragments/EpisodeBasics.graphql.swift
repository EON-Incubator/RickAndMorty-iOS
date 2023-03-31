// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  struct EpisodeBasics: RickAndMortyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString { """
      fragment episodeBasics on Episode {
        __typename
        air_date
        episode
        id
        name
      }
      """ }

    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Episode }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("air_date", String?.self),
      .field("episode", String?.self),
      .field("id", RickAndMortyAPI.ID?.self),
      .field("name", String?.self),
    ] }

    /// The air date of the episode.
    public var air_date: String? { __data["air_date"] }
    /// The code of the episode.
    public var episode: String? { __data["episode"] }
    /// The id of the episode.
    public var id: RickAndMortyAPI.ID? { __data["id"] }
    /// The name of the episode.
    public var name: String? { __data["name"] }
  }

}