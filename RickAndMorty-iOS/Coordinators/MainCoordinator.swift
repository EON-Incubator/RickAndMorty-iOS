//
//  MainCoordinator.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit

class MainCoordinator: Coordinator {

    let window: UIWindow

    var tabBarController = UITabBarController()

    let characterNavController = UINavigationController()
    let locationNavController = UINavigationController()
    let episodeNavController = UINavigationController()
    let searchNavController = UINavigationController()

    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()

        let shadow = NSShadow()
        shadow.shadowColor = UIColor.label
        shadow.shadowBlurRadius = 0.5

        customNavBarAppearance.largeTitleTextAttributes = [.font: UIFont(name: "Creepster-Regular", size: 34)!,
                                                           .foregroundColor: UIColor.label,
                                                           .shadow: shadow]
        customNavBarAppearance.titleTextAttributes = [.font: UIFont(name: "Creepster-Regular", size: 27)!,
                                                      .foregroundColor: UIColor.systemCyan,
                                                      .shadow: shadow]

        customNavBarAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        customNavBarAppearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward.circle"),
                                                     transitionMaskImage: UIImage(systemName: "arrow.backward.circle"))

        return customNavBarAppearance
    }

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // Configure tab bar.
        tabBarController.tabBar.backgroundColor = .systemBackground

        let navBarAppearance = customNavBarAppearance()

        // Add navigation controllers to the tab bar and set the title and icon for each tab.
        tabBarController.addChild(characterNavController)
        characterNavController.tabBarItem.image = UIImage(systemName: "person.text.rectangle")
        characterNavController.tabBarItem.title = "Characters"
        characterNavController.navigationBar.standardAppearance = navBarAppearance

        tabBarController.addChild(locationNavController)
        locationNavController.tabBarItem.image = UIImage(systemName: "map")
        locationNavController.tabBarItem.title = "Locations"
        locationNavController.navigationBar.standardAppearance = navBarAppearance

        tabBarController.addChild(episodeNavController)
        episodeNavController.tabBarItem.image = UIImage(systemName: "tv")
        episodeNavController.tabBarItem.title = "Episodes"
        episodeNavController.navigationBar.standardAppearance = navBarAppearance

        tabBarController.addChild(searchNavController)
        searchNavController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNavController.tabBarItem.title = "Search"
        searchNavController.navigationBar.standardAppearance = navBarAppearance

        // Add CharactersViewController to the character navigation controller.
        let charactersViewController = CharactersViewController()
        charactersViewController.coordinator = self
        characterNavController.pushViewController(charactersViewController, animated: false)

        // Add LocationsViewController to the location navigation controller.
        let locationsViewController = LocationsViewController()
        locationsViewController.coordinator = self
        locationNavController.pushViewController(locationsViewController, animated: false)

        // Add EpisodesViewController to the episode navigation controller.
        let episodesViewController = EpisodesViewController()
        episodesViewController.coordinator = self
        episodeNavController.pushViewController(episodesViewController, animated: false)

        // Add SearchViewController to the search navigation controller.
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        searchNavController.pushViewController(searchViewController, animated: false)

        // Set tab bar controller as the root view controller of the UIWindow.
        window.tintColor = .label
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        let viewController = CharacterDetailsViewController()
        viewController.coordinator = self
        viewController.characterID = id
        navController.pushViewController(viewController, animated: true)
    }

    func showCharactersFilter(sender: UIViewController, viewModel: CharactersViewModel) {
        let charactersFilterViewController = CharactersFilterViewController(viewModel: viewModel)
        charactersFilterViewController.modalPresentationStyle = .popover
        if let popover = charactersFilterViewController.popoverPresentationController {
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [
                .custom(identifier: UISheetPresentationController.Detent.Identifier("small")) { _ in
                    280
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        sender.present(charactersFilterViewController, animated: true, completion: nil)
    }

    func goLocationDetails(id: String, navController: UINavigationController) {
        let viewController = LocationDetailsViewController(locationId: id)
        viewController.coordinator = self
        navController.pushViewController(viewController, animated: true)
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        let viewController = EpisodeDetailsViewController(episodeId: id)
        viewController.coordinator = self
        navController.pushViewController(viewController, animated: true)
    }

}
