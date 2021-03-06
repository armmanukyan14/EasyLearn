//
//  SceneDelegate.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard (scene as? UIWindowScene) != nil else { return }

        let navigationController = window?.rootViewController as? UINavigationController

        navigationController?.setNavigationBarHidden(true, animated: false)

         let initialVC = UIStoryboard.main.instantiateViewController(identifier: "WelcomeViewController")
        
            navigationController?.setViewControllers([initialVC], animated: false)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

