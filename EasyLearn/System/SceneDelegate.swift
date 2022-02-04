//
//  SceneDelegate.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func setLightMode() {
        window?.overrideUserInterfaceStyle = .light
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene as? UIWindowScene) != nil else { return }

        setLightMode()

        let userDefaultsHelper = UserDefaultsHelper.shared

        let navigationController = window?.rootViewController as? UINavigationController

        navigationController?.setNavigationBarHidden(true, animated: false)

//        var initialVC: UIViewController
//        if userDefaultsHelper.isLoggedOut {
//            initialVC = WelcomeViewController.getInstance(from: .main)
//        }
//        if userDefaultsHelper.isLoggedIn {
//            initialVC = BaseViewController.getInstance(from: .base)
//        } else {
//            initialVC = WelcomeViewController.getInstance(from: .main)
//        }

//        navigationController?.setViewControllers([initialVC], animated: false)

        let initialVC = BaseViewController.getInstance(from: .base)
        navigationController?.setViewControllers([initialVC], animated: false)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
