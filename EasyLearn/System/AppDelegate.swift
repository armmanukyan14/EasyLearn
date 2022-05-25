//
//  AppDelegate.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user == nil {
                self?.showAuth()
            }
        }
        return true
    }

    func showAuth() {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        self.window?.rootViewController?.present(vc, animated: false, completion: nil)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
