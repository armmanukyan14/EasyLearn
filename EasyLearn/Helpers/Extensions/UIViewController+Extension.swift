//
//  UIViewController+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 22.11.21.
//

import UIKit

extension UIViewController {
    static func getInstance(from storyboard: UIStoryboard) -> Self {
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
        else { fatalError() }
        return viewController
    }
}
