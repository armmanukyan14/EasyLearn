//
//  UITextField+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 26.01.22.
//

import UIKit

extension UITextField {
    static func setupTextField(placeholder: String, textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10.0
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = textFieldPadding
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }
}
