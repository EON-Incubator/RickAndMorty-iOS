// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import RickAndMorty-iOS

public class Location: MockObject {
  public static let objectType: Object = RickAndMortyAPI.Objects.Location
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Location>>

  public struct MockFields {
    @Field<String>("created") public var created
    @Field<String>("dimension") public var dimension
    @Field<RickAndMortyAPI.ID>("id") public var id
    @Field<String>("name") public var name
    @Field<[Character?]>("residents") public var residents
    @Field<String>("type") public var type
  }
}

public extension Mock where O == Location {
  convenience init(
    created: String? = nil,
    dimension: String? = nil,
    id: RickAndMortyAPI.ID? = nil,
    name: String? = nil,
    residents: [Mock<Character>?]? = nil,
    type: String? = nil
  ) {
    self.init()
    self.created = created
    self.dimension = dimension
    self.id = id
    self.name = name
    self.residents = residents
    self.type = type
  }
}
