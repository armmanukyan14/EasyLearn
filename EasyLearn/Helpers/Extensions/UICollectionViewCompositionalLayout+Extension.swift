//
//  UICollectionViewCompositionalLayout+Extension.swift
//  EasyLearn
//
//  Created by MacBook on 22.01.22.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    static func getCompositionalLayout(height: CGFloat) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
//      section.interGroupSpacing = 10

        return UICollectionViewCompositionalLayout(section: section)
    }
}
