//
//  UserDefaults.swift
//  EasyLearn
//
//  Created by MacBook on 10.01.22.
//

import Foundation

class UserDefaultsHelper {

    // MARK: - Properties

    let standard = UserDefaults.standard

    // MARK: - Singleton

    static let shared = UserDefaultsHelper()
    private init() {}

    enum Key: String {
        case isLoggedIn
    }

    var isLoggedIn: Bool {
        standard.bool(forKey: Key.isLoggedIn.rawValue)
    }

    func set(isLoggedIn: Bool) {
        standard.set(isLoggedIn, forKey: Key.isLoggedIn.rawValue)
    }
}
