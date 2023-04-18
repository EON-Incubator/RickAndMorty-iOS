// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import RickAndMorty-iOS

public class Episode: MockObject {
  public static let objectType: Object = RickAndMortyAPI.Objects.Episode
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Episode>>

  public struct MockFields {
    @Field<String>("air_date") public var air_date
    @Field<[Character?]>("characters") public var characters
    @Field<String>("created") public var created
    @Field<String>("episode") public var episode
    @Field<RickAndMortyAPI.ID>("id") public var id
    @Field<String>("name") public var name
  }
}

public extension Mock where O == Episode {
  convenience init(
    air_date: String? = nil,
    characters: [Mock<Character>?]? = nil,
    created: String? = nil,
    episode: String? = nil,
    id: RickAndMortyAPI.ID? = nil,
    name: String? = nil
  ) {
    self.init()
    self.air_date = air_date
    self.characters = characters
    self.created = created
    self.episode = episode
    self.id = id
    self.name = name
  }
}
