//
//  SearchCollectionViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 24.08.21.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var previewImage: UIImageView! { didSet {
        previewImage.backgroundColor = .green
        previewImage.layer.cornerRadius = 10.0
    }
    }
}
