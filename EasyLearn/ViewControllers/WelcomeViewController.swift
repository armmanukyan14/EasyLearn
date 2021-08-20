//
//  WelcomeViewController.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit

class WelcomeViewController: UIViewController {

@IBOutlet private var loremIpsumLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
    }

   func setupLabels() {
    loremIpsumLabel.textColor = UIColor.loremIpsum
    loremIpsumLabel.font = UIFont(name: "BalooBhai2", size: 30)
    }


}

