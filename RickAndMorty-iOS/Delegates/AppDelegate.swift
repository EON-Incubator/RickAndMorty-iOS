//
//  AppDelegate.swift
//  RickAndMorty-iOS
//
//  Created by Calvin Pak on 2023-03-08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Network.shared.setOfflineMode(false)

        Network.shared.networkMontior.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Connected
                let isDownloadCompleted = Network.shared.isDownloadCompleted()
                Network.shared.setOfflineMode(isDownloadCompleted)
                Network.shared.checkForUpdate()
            } else {
                // Disconnected
                Network.shared.setOfflineMode(true)
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        Network.shared.networkMontior.start(queue: queue)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting
                     connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions
                     sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after
        // application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
