// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class SearchForQuery: GraphQLQuery {
    public static let operationName: String = "searchFor"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query searchFor($keyword: String) {
          characters(filter: {name: $keyword}) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...characterBasics
            }
          }
          locationsWithName: locations(filter: {name: $keyword}) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...locationDetails
            }
          }
          locationsWithType: locations(filter: {type: $keyword}) {
            __typename
            info {
              __typename
              ...pageInfo
            }
            results {
              __typename
              ...locationDetails
            }
          }
        }
        """#,
        fragments: [PageInfo.self, CharacterBasics.self, LocationDetails.self, LocationBasics.self]
      ))

    public var keyword: GraphQLNullable<String>

    public init(keyword: GraphQLNullable<String>) {
      self.keyword = keyword
    }

    public var __variables: Variables? { ["keyword": keyword] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("characters", Characters?.self, arguments: ["filter": ["name": .variable("keyword")]]),
        .field("locations", alias: "locationsWithName", LocationsWithName?.self, arguments: ["filter": ["name": .variable("keyword")]]),
        .field("locations", alias: "locationsWithType", LocationsWithType?.self, arguments: ["filter": ["type": .variable("keyword")]]),
      ] }

      /// Get the list of all characters
      public var characters: Characters? { __data["characters"] }
      /// Get the list of all locations
      public var locationsWithName: LocationsWithName? { __data["locationsWithName"] }
      /// Get the list of all locations
      public var locationsWithType: LocationsWithType? { __data["locationsWithType"] }

      /// Characters
      ///
      /// Parent Type: `Characters`
      public struct Characters: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Characters }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("info", Info?.self),
          .field("results", [Result?]?.self),
        ] }

        public var info: Info? { __data["info"] }
        public var results: [Result?]? { __data["results"] }

        /// Characters.Info
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

        /// Characters.Result
        ///
        /// Parent Type: `Character`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(CharacterBasics.self),
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

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var characterBasics: CharacterBasics { _toFragment() }
          }
        }
      }

      /// LocationsWithName
      ///
      /// Parent Type: `Locations`
      public struct LocationsWithName: RickAndMortyAPI.SelectionSet {
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

        /// LocationsWithName.Info
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

        /// LocationsWithName.Result
        ///
        /// Parent Type: `Location`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(LocationDetails.self),
          ] }

          /// The id of the location.
          public var id: RickAndMortyAPI.ID? { __data["id"] }
          /// The dimension in which the location is located.
          public var dimension: String? { __data["dimension"] }
          /// The name of the location.
          public var name: String? { __data["name"] }
          /// The type of the location.
          public var type: String? { __data["type"] }
          /// List of characters who have been last seen in the location.
          public var residents: [Resident?] { __data["residents"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var locationDetails: LocationDetails { _toFragment() }
            public var locationBasics: LocationBasics { _toFragment() }
          }

          /// LocationsWithName.Result.Resident
          ///
          /// Parent Type: `Character`
          public struct Resident: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }

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

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var characterBasics: CharacterBasics { _toFragment() }
            }
          }
        }
      }

      /// LocationsWithType
      ///
      /// Parent Type: `Locations`
      public struct LocationsWithType: RickAndMortyAPI.SelectionSet {
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

        /// LocationsWithType.Info
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

        /// LocationsWithType.Result
        ///
        /// Parent Type: `Location`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(LocationDetails.self),
          ] }

          /// The id of the location.
          public var id: RickAndMortyAPI.ID? { __data["id"] }
          /// The dimension in which the location is located.
          public var dimension: String? { __data["dimension"] }
          /// The name of the location.
          public var name: String? { __data["name"] }
          /// The type of the location.
          public var type: String? { __data["type"] }
          /// List of characters who have been last seen in the location.
          public var residents: [Resident?] { __data["residents"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var locationDetails: LocationDetails { _toFragment() }
            public var locationBasics: LocationBasics { _toFragment() }
          }

          /// LocationsWithType.Result.Resident
          ///
          /// Parent Type: `Character`
          public struct Resident: RickAndMortyAPI.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }

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

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var characterBasics: CharacterBasics { _toFragment() }
            }
          }
        }
      }
    }
  }

}