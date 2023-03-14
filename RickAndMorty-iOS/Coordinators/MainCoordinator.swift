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

    // MARK: - Setup demo tab for experiment
    let demoNavController = UINavigationController()

    func setupDemo() {
        tabBarController.addChild(demoNavController)
        demoNavController.tabBarItem.title = "Demo"
        let demoViewController = DemoViewController()
        demoViewController.coordinator = self
        demoNavController.navigationBar.backgroundColor = .systemBackground
        demoNavController.pushViewController(demoViewController, animated: false)
    }
    // MARK: -

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        // Configure tab bar.
        tabBarController.tabBar.backgroundColor = .systemBackground

        // Add navigation controllers to the tab bar and set the title and icon for each tab.
        tabBarController.addChild(characterNavController)
        characterNavController.tabBarItem.image = UIImage(systemName: "person.text.rectangle")
        characterNavController.tabBarItem.title = "Characters"

        tabBarController.addChild(locationNavController)
        locationNavController.tabBarItem.image = UIImage(systemName: "map")
        locationNavController.tabBarItem.title = "Locations"

        tabBarController.addChild(episodeNavController)
        episodeNavController.tabBarItem.image = UIImage(systemName: "tv")
        episodeNavController.tabBarItem.title = "Episodes"

        tabBarController.addChild(searchNavController)
        searchNavController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNavController.tabBarItem.title = "Search"

        // Add CharactersViewController to the character navigation controller.
        let viewController = CharactersViewController()
        viewController.coordinator = self
        characterNavController.navigationBar.backgroundColor = .systemBackground
        characterNavController.pushViewController(viewController, animated: false)

        // Add LocationsViewController to the location navigation controller.
        let locationsViewController = LocationsViewController()
        locationsViewController.coordinator = self
        locationNavController.navigationBar.backgroundColor = .systemBackground
        locationNavController.pushViewController(locationsViewController, animated: false)

        // Add EpisodesViewController to the episode navigation controller.
        let episodesViewController = EpisodesViewController()
        episodesViewController.coordinator = self
        episodeNavController.navigationBar.backgroundColor = .systemBackground
        episodeNavController.pushViewController(episodesViewController, animated: false)

        // MARK: - Setup demo tab for experiment, remove this from production.
        setupDemo()
        // MARK: -

        // Set tab bar controller as the root view controller of the UIWindow.
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        let viewController = CharacterDetailsViewController()
        viewController.coordinator = self
        viewController.characterID = id
        navController.pushViewController(viewController, animated: true)
    }

    func goLocationDetails(id: Int, navController: UINavigationController) {

    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        let viewController = EpisodeDetailsViewController(episodeId: id)
        viewController.coordinator = self
        navController.pushViewController(viewController, animated: true)
    }

}
