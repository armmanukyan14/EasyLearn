//
//  UIColor+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import Foundation
import UIKit

extension UIColor {
    static var easyPurple: Self {
        .init(red: 103 / 255, green: 45 / 255, blue: 227 / 255, alpha: 1)
    }

    static var easyDarkGray: Self {
        .init(red: 87 / 255, green: 80 / 255, blue: 102 / 255, alpha: 1)
    }

    static var easyGray: Self {
        .init(red: 69 / 255, green: 66 / 255, blue: 72 / 255, alpha: 0.32)
    }

    static var labelColor: Self {
        .init(red: 107 / 255, green: 107 / 255, blue: 107 / 255, alpha: 1)
    }

    static var textFieldBorderColor: Self {
        .init(red: 133 / 255, green: 140 / 255, blue: 148 / 255, alpha: 1)
    }

    static var textFieldPlaceholderColor: Self {
        .init(red: 109 / 255, green: 117 / 255, blue: 128 / 255, alpha: 1)
    }

    static var nextButtonColor: Self {
        .init(red: 190 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)
    }

    static var searchTextFieldColor: Self {
        .init(red: 235 / 255, green: 235 / 255, blue: 236 / 255, alpha: 1)
    }

    static var redViewColor: Self {
        .init(red: 239 / 255, green: 87 / 255, blue: 82 / 255, alpha: 0.5)
    }

    static var greenViewColor: Self {
        .init(red: 89 / 255, green: 236 / 255, blue: 113 / 255, alpha: 0.5)
    }

    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
