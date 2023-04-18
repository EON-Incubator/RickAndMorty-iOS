// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol RickAndMortyAPI_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == RickAndMortyAPI.SchemaMetadata {}

public protocol RickAndMortyAPI_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == RickAndMortyAPI.SchemaMetadata {}

public protocol RickAndMortyAPI_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == RickAndMortyAPI.SchemaMetadata {}

public protocol RickAndMortyAPI_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == RickAndMortyAPI.SchemaMetadata {}

public extension RickAndMortyAPI {
  typealias ID = String

  typealias SelectionSet = RickAndMortyAPI_SelectionSet

  typealias InlineFragment = RickAndMortyAPI_InlineFragment

  typealias MutableSelectionSet = RickAndMortyAPI_MutableSelectionSet

  typealias MutableInlineFragment = RickAndMortyAPI_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> Object? {
      switch typename {
      case "Query": return RickAndMortyAPI.Objects.Query
      case "Episodes": return RickAndMortyAPI.Objects.Episodes
      case "Info": return RickAndMortyAPI.Objects.Info
      case "Characters": return RickAndMortyAPI.Objects.Characters
      case "Character": return RickAndMortyAPI.Objects.Character
      case "Episode": return RickAndMortyAPI.Objects.Episode
      case "Location": return RickAndMortyAPI.Objects.Location
      case "Locations": return RickAndMortyAPI.Objects.Locations
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}