//
//  User.swift
//  EasyLearn
//
//  Created by MacBook on 17.09.21.
//

import UIKit

struct User: Encodable {
    let id: String
    var name: String
    var image: String
    var videos: [URL]
}
