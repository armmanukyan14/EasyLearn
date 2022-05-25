//
//  SavedVideosCollectionViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 20.01.22.
//

import UIKit

class SavedVideosCollectionViewCell: UICollectionViewCell {

    @IBOutlet var savedVideoView: UIView! { didSet {
        savedVideoView.layer.cornerRadius = 10
        savedVideoView.backgroundColor = .random()
    }}
}
