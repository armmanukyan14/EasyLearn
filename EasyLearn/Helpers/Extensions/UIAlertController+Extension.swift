//
//  UIAlertController+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 26.02.22.
//

import UIKit

extension UIAlertController {
    static func setAlertButtonColor() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.easyPurple
    }
}
