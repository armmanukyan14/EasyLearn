//
//  NSAttributedString+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 26.02.22.
//

import UIKit

extension NSAttributedString {
    static func setAlert(title: String) -> NSAttributedString {
        NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor
        ])
    }
}
