//
//  SceneDelegate.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit
import Network

let monitor = NWPathMonitor()

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
        
        var initialVC: UIViewController
        if userDefaultsHelper.isLoggedIn {
            initialVC = BaseViewController.getInstance(from: .base)
        } else {
            initialVC = WelcomeViewController.getInstance(from: .main)
        }
        
        navigationController?.setViewControllers([initialVC], animated: false)
        
//        let noInternetVC = NoInternetViewController.getInstance(from: .noInternet)
  
        let queue = DispatchQueue.main
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
//            if path.usesInterfaceType(.wifi) {
            switch path.status {
//            case .satisfied:
//                print("Satisfied")
//                noInternetVC.dismiss(animated: false)
            case .unsatisfied:
                print("Unsatisfied")
//                noInternetVC.modalPresentationStyle = .fullScreen
//                navigationController?.present(noInternetVC, animated: false)
//            case .requiresConnection:
//                print("Requires")
            default:
                print("Default")
//            }
            }
        }
        
//        monitor.pathUpdateHandler = { path in
//
//            if path.status == .satisfied && path.usesInterfaceType(.wifi) {
//                print("Satisfied")
//            } else {
//                print("Unsatisfied")
//            }
//        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
