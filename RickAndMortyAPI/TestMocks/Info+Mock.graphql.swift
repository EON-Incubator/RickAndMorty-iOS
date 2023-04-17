// @generated
// This file was automatically generated and should not be edited.

import ApolloTestSupport
import RickAndMorty-iOS

public class Info: MockObject {
  public static let objectType: Object = RickAndMortyAPI.Objects.Info
  public static let _mockFields = MockFields()
  public typealias MockValueCollectionType = Array<Mock<Info>>

  public struct MockFields {
    @Field<Int>("count") public var count
    @Field<Int>("next") public var next
    @Field<Int>("pages") public var pages
    @Field<Int>("prev") public var prev
  }
}

public extension Mock where O == Info {
  convenience init(
    count: Int? = nil,
    next: Int? = nil,
    pages: Int? = nil,
    prev: Int? = nil
  ) {
    self.init()
    self.count = count
    self.next = next
    self.pages = pages
    self.prev = prev
  }
}
