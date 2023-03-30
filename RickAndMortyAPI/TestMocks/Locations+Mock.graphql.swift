// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import RickAndMorty_iOS

public class Locations: MockObject {
  public static let objectType: Object = RickAndMortyAPI.Objects.Locations
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Locations>>

  public struct MockFields {
    @Field<Info>("info") public var info
    @Field<[Location?]>("results") public var results
  }
}

public extension Mock where O == Locations {
  convenience init(
    info: Mock<Info>? = nil,
    results: [Mock<Location>?]? = nil
  ) {
    self.init()
    self.info = info
    self.results = results
  }
}
