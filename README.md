# RickAndMorty-iOS
Final project of EON Mobile Incubator W23

Mobile app that consume the public RickyAndMorty GraphQL
  - URL - https://rickandmortyapi.com/graphql
  - Docs - https://rickandmortyapi.com/documentation

**Ground Rules**

* You must use Swift
* You must use MVVM as the app architecture
  * You are free to use other patterns that build on top of MVVM (e.g. MVVM+Coordinators)
* You must use UIKit for iOS and your views should be created programmatically
  * Do not use Storyboards or XIB files
  * Do not use SwiftUI
  * You are free to use dependencies to help! (e.g. with the creation of views and management of autolayout constraints)
* Your implementation should use asynchronous and reactive programming concepts (i.e. Combine, Closures, DispatchQueues, SwiftConcurrency)
* You must use Apollo GraphQL to interact with the Ricky and Morty GraphQL API
* You should have test coverage over 70% on your view models
  * You should explore both Unit and BDD testing
* For dependency management you’re encouraged to use Swift Package Manager
* Carthage is okay as well! If you choose to go that route
* You must setup Swiftlint locally and add it as a pre-commit hook to ensure your code is being linted
  * Read more about git hooks here https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
  * Swiftlint must also be setup as a Github Check to run on all pull requests and this check must pass for a PR to be merged
