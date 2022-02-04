//
//  Validator.swift
//  EasyLearn
//
//  Created by MacBook on 17.09.21.
//

import Foundation

enum Validator {
    static func validate(email: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let isValid = emailPredicate.evaluate(with: email)

        if email.isEmpty {
            return "This field is required!"
        } else if !isValid {
            return "Invalid e-mail address!"
        } else {
            return nil
        }
    }

    static func validate(password: String) -> String? {
        let passwordRegEx = ".{6,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        let isValid = passwordPredicate.evaluate(with: password)
        if password.isEmpty {
            return "This field is required!"
        } else if !isValid {
            return "At least 6 letters or numbers!"
        } else {
            return nil
        }
    }

    static func validate(field: String) -> String? {
        let isValid = !field.isEmpty
        return isValid ? nil : "This field cannot be empty!"
    }
}
