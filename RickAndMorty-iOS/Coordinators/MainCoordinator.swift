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
        let viewController = CharactersViewController() // To try the DemoView, replace it with DemoViewController()
        viewController.coordinator = self
        characterNavController.navigationBar.backgroundColor = .systemBackground
        characterNavController.pushViewController(viewController, animated: false)

        // Set tab bar controller as the root view controller of the UIWindow.
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func goCharacterDetails(id: Int, navController: UINavigationController) {

    }

    func goLocationDetails(id: Int, navController: UINavigationController) {

    }

    func goEpisodeDetails(id: Int, navController: UINavigationController) {

    }

}
