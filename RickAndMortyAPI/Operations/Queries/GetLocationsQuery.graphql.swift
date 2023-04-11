// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetLocationsQuery: GraphQLQuery {
    public static let operationName: String = "getLocations"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getLocations($page: Int, $name: String, $type: String) {
          locations(page: $page, filter: {name: $name, type: $type}) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...locationDetails
              ...locationBasics
              residents {
                __typename
                image
              }
            }
          }
        }
        """#,
        fragments: [PageInfo.self, LocationDetails.self, LocationBasics.self]
      ))

    public var page: GraphQLNullable<Int>
    public var name: GraphQLNullable<String>
    public var type: GraphQLNullable<String>

    public init(
      page: GraphQLNullable<Int>,
      name: GraphQLNullable<String>,
      type: GraphQLNullable<String>
    ) {
      self.page = page
      self.name = name
      self.type = type
    }

    public var __variables: Variables? { [
      "page": page,
      "name": name,
      "type": type
    ] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("locations", Locations?.self, arguments: [
          "page": .variable("page"),
          "filter": [
            "name": .variable("name"),
            "type": .variable("type")
          ]
        ]),
      ] }

      /// Get the list of all locations
      public var locations: Locations? { __data["locations"] }

      /// Locations
      ///
      /// Parent Type: `Locations`
      public struct Locations: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Locations }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("info", Info?.self),
          .field("results", [Result?]?.self),
        ] }

        public var info: Info? { __data["info"] }
        public var results: [Result?]? { __data["results"] }

        /// Locations.Info
        ///
        /// Parent Type: `Info`
        public struct Info: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Info }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PageInfo.self),
          ] }

          /// The length of the response.
          public var count: Int? { __data["count"] }
          /// The amount of pages.
          public var pages: Int? { __data["pages"] }
          /// Number of the previous page (if it exists)
          public var prev: Int? { __data["prev"] }
          /// Number of the next page (if it exists)
          public var next: Int? { __data["next"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pageInfo: PageInfo { _toFragment() }
          }
        }

        /// Locations.Result
        ///
        /// Parent Type: `Location`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("residents", [Resident?].self),
            .fragment(LocationDetails.self),
            .fragment(LocationBasics.self),
          ] }

          /// List of characters who have been last seen in the location.
          public var residents: [Resident?] { __data["residents"] }
          /// The id of the location.
          public var id: RickAndMortyAPI.ID? { __data["id"] }
          /// The dimension in which the location is located.
          public var dimension: String? { __data["dimension"] }
          /// The name of the location.
          public var name: String? { __data["name"] }
          /// The type of the location.
          public var type: String? { __data["type"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var locationDetails: LocationDetails { _toFragment() }
            public var locationBasics: LocationBasics { _toFragment() }
          }

          /// Locations.Result.Resident
          ///
          /// Parent Type: `Character`
          public struct Resident: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("image", String?.self),
            ] }

            /// Link to the character's image.
            /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
            public var image: String? { __data["image"] }
          }
        }
      }
    }
  }

}