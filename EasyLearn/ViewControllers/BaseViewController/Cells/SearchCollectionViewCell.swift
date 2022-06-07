//
//  SearchCollectionViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 19.01.22.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet var searchVideoView: UIView! { didSet {
        searchVideoView.layer.cornerRadius = 10
        searchVideoView.backgroundColor = .random()
    }}

    @IBOutlet var videoNameLabel: UILabel! { didSet{
        videoNameLabel.layer.cornerRadius = 5
        videoNameLabel.clipsToBounds = true
    }}

    func setVideoNameLabel(name: String) {
        videoNameLabel.text = name
    }
}
