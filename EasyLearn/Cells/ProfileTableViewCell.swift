//
//  File.swift
//  EasyLearn
//
//  Created by MacBook on 27.09.21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet private var view1: UIView! { didSet {
        view1.layer.cornerRadius = 10.0
    }}
    @IBOutlet private var view2: UIView! { didSet {
        view2.layer.cornerRadius = 10.0
    }}
}
