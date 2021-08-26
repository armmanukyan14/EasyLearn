//
//  SearchTableViewCell.swift
//  EasyLearn
//
//  Created by MacBook on 24.08.21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet private var collectionView: UICollectionView! { didSet {
        collectionView.delegate = self
        collectionView.dataSource = self
//        collectionView.reloadData()
    }}
}

extension SearchTableViewCell: UICollectionViewDelegate {}

extension SearchTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        return cell
    }
}


