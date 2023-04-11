// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  struct PageInfo: RickAndMortyAPI.SelectionSet, Fragment {
    public static var fragmentDefinition: StaticString { """
      fragment pageInfo on Info {
        __typename
        count
        pages
        prev
        next
      }
      """ }

    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Info }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("count", Int?.self),
      .field("pages", Int?.self),
      .field("prev", Int?.self),
      .field("next", Int?.self),
    ] }

    /// The length of the response.
    public var count: Int? { __data["count"] }
    /// The amount of pages.
    public var pages: Int? { __data["pages"] }
    /// Number of the previous page (if it exists)
    public var prev: Int? { __data["prev"] }
    /// Number of the next page (if it exists)
    public var next: Int? { __data["next"] }
  }

}