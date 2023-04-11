// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import RickAndMorty-iOS

public class Query: MockObject {
  public static let objectType: Object = RickAndMortyAPI.Objects.Query
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Query>>

  public struct MockFields {
    @Field<Character>("character") public var character
    @Field<Characters>("characters") public var characters
    @Field<Episode>("episode") public var episode
    @Field<Episodes>("episodes") public var episodes
    @Field<Location>("location") public var location
    @Field<Locations>("locations") public var locations
    @Field<Locations>("locationsWithName") public var locationsWithName
    @Field<Locations>("locationsWithType") public var locationsWithType
  }
}

public extension Mock where O == Query {
  convenience init(
    character: Mock<Character>? = nil,
    characters: Mock<Characters>? = nil,
    episode: Mock<Episode>? = nil,
    episodes: Mock<Episodes>? = nil,
    location: Mock<Location>? = nil,
    locations: Mock<Locations>? = nil,
    locationsWithName: Mock<Locations>? = nil,
    locationsWithType: Mock<Locations>? = nil
  ) {
    self.init()
    self.character = character
    self.characters = characters
    self.episode = episode
    self.episodes = episodes
    self.location = location
    self.locations = locations
    self.locationsWithName = locationsWithName
    self.locationsWithType = locationsWithType
  }
}
