// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension RickAndMortyAPI {
  class GetCharactersQuery: GraphQLQuery {
    public static let operationName: String = "getCharacters"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query getCharacters($page: Int, $name: String, $status: String, $gender: String) {
          characters(page: $page, filter: {name: $name, status: $status, gender: $gender}) {
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
        }
        """#,
        fragments: [PageInfo.self, CharacterBasics.self]
      ))

    public var page: GraphQLNullable<Int>
    public var name: GraphQLNullable<String>
    public var status: GraphQLNullable<String>
    public var gender: GraphQLNullable<String>

    public init(
      page: GraphQLNullable<Int>,
      name: GraphQLNullable<String>,
      status: GraphQLNullable<String>,
      gender: GraphQLNullable<String>
    ) {
      self.page = page
      self.name = name
      self.status = status
      self.gender = gender
    }

    public var __variables: Variables? { [
      "page": page,
      "name": name,
      "status": status,
      "gender": gender
    ] }

    public struct Data: RickAndMortyAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("characters", Characters?.self, arguments: [
          "page": .variable("page"),
          "filter": [
            "name": .variable("name"),
            "status": .variable("status"),
            "gender": .variable("gender")
          ]
        ]),
      ] }

      /// Get the list of all characters
      public var characters: Characters? { __data["characters"] }

      /// Characters
      ///
      /// Parent Type: `Characters`
      public struct Characters: RickAndMortyAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Characters }
        public static var __selections: [ApolloAPI.Selection] { [
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
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Info }
          public static var __selections: [ApolloAPI.Selection] { [
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
            public init(data: DataDict) { __data = data }

            public var pageInfo: PageInfo { _toFragment() }
          }
        }

        /// Characters.Result
        ///
        /// Parent Type: `Character`
        public struct Result: RickAndMortyAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { RickAndMortyAPI.Objects.Character }
          public static var __selections: [ApolloAPI.Selection] { [
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
            public init(data: DataDict) { __data = data }

            public var characterBasics: CharacterBasics { _toFragment() }
          }
        }
      }
    }
  }

}