//
//  BaseViewController.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import UIKit

class BaseViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        removeTitle()
    }

    private func removeTitle() {
            if let tab = self.tabBar.items, let currentTab = self.selectedViewController {
                tab.forEach {
                    if currentTab != self {
                        $0.title = ""
                    }
                }
            }
        }
}

