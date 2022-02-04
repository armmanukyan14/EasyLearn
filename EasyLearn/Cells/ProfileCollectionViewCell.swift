//
//  ProfileCollectionViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 20.01.22.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet var profileVideoView: UIView! { didSet {
        profileVideoView.layer.cornerRadius = 10
        profileVideoView.backgroundColor = .random()
    }}
}
