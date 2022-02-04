//
//  CGFloat+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 18.01.22.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
