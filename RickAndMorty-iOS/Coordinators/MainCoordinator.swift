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

        customNavBarAppearance.largeTitleTextAttributes = [.font: UIFont(name: K.Fonts.primary, size: 34)!,
                                                           .foregroundColor: UIColor.label,
                                                           .shadow: shadow]
        customNavBarAppearance.titleTextAttributes = [.font: UIFont(name: K.Fonts.primary, size: 27)!,
                                                      .foregroundColor: UIColor.systemCyan,
                                                      .shadow: shadow]

        customNavBarAppearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
        customNavBarAppearance.setBackIndicatorImage(UIImage(systemName: K.Images.systemBackArrow),
                                                     transitionMaskImage: UIImage(systemName: K.Images.systemBackArrow))

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
        configureTab(navController: characterNavController, image: UIImage(systemName: K.Images.systemCharacters), title: K.Titles.characters, barAppearance: navBarAppearance)
        configureTab(navController: locationNavController, image: UIImage(systemName: K.Images.map), title: K.Titles.locations, barAppearance: navBarAppearance)
        configureTab(navController: episodeNavController, image: UIImage(systemName: K.Images.television), title: K.Titles.episodes, barAppearance: navBarAppearance)
        configureTab(navController: searchNavController, image: UIImage(systemName: K.Images.systemMagnifyingGlass), title: K.Titles.search, barAppearance: navBarAppearance)

        // Add CharactersViewController to the character navigation controller.
        let charactersViewModel = CharactersViewModel()
        charactersViewModel.coordinator = self
        let charactersViewController = CharactersViewController(viewModel: charactersViewModel)
        characterNavController.pushViewController(charactersViewController, animated: false)

        // Add LocationsViewController to the location navigation controller.
        let locationsViewModel = LocationsViewModel()
        locationsViewModel.coordinator = self
        let locationsViewController = LocationsViewController(viewModel: locationsViewModel)
        locationNavController.pushViewController(locationsViewController, animated: false)

        // Add EpisodesViewController to the episode navigation controller.
        let episodeViewModel = EpisodesViewModel()
        episodeViewModel.coordinator = self
        let episodesViewController = EpisodesViewController(viewModel: episodeViewModel)
        episodeNavController.pushViewController(episodesViewController, animated: false)

        // Add SearchViewController to the search navigation controller.
        let searchViewModel = SearchViewModel()
        searchViewModel.coordinator = self
        let searchViewController = SearchViewController(viewModel: searchViewModel)
        searchNavController.pushViewController(searchViewController, animated: false)

        // Set tab bar controller as the root view controller of the UIWindow.
        window.tintColor = .label
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    func configureTab(navController: UINavigationController, image: UIImage?, title: String, barAppearance: UINavigationBarAppearance) {
        tabBarController.addChild(navController)
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        navController.navigationBar.standardAppearance = barAppearance
    }

    func goCharacterDetails(id: String, navController: UINavigationController) {
        let viewModel = CharacterDetailsViewModel(characterId: id)
        viewModel.coordinator = self
        let viewController = CharacterDetailsViewController(viewModel: viewModel)
        navController.pushViewController(viewController, animated: true)
    }

    func showCharactersFilter(viewController: UIViewController, viewModel: CharactersViewModel, sender: AnyObject, onDismiss: (() -> Void)? = nil) {
        let charactersFilterViewController = CharactersFilterViewController(viewModel: viewModel, onDismiss: onDismiss)

        charactersFilterViewController.modalPresentationStyle = .popover
        if let popover = charactersFilterViewController.popoverPresentationController {
            popover.sourceView = sender as? UIView
            popover.sourceRect = sender.bounds
            popover.delegate = viewController as? UIPopoverPresentationControllerDelegate
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [
                .custom(identifier: UISheetPresentationController.Detent.Identifier("small")) { _ in
                    return 280
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersEdgeAttachedInCompactHeight = true
        }
        viewController.present(charactersFilterViewController, animated: true, completion: nil)
    }

    func dismissCharactersFilter(viewController: UIViewController) {
        viewController.dismiss(animated: true)
    }

    func goLocationDetails(id: String, navController: UINavigationController) {
        let viewModel = LocationDetailsViewModel(locationId: id)
        viewModel.locationId = id
        viewModel.coordinator = self
        let viewController = LocationDetailsViewController(viewModel: viewModel)
        navController.pushViewController(viewController, animated: true)
    }

    func goEpisodeDetails(id: String, navController: UINavigationController) {
        let viewModel = EpisodeDetailsViewModel(episodeId: id)
        viewModel.episodeId = id
        viewModel.coordinator = self
        let viewController = EpisodeDetailsViewController(viewModel: viewModel)
        navController.pushViewController(viewController, animated: true)
    }

}
