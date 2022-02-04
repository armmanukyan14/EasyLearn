//
//  SavedVideosViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.01.22.
//

import UIKit

class SavedVideosViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }

    // MARK: - Methods
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.getCompositionalLayout(height: 130),
                                               animated: false)
    }
}

    // MARK: - Extensions

extension SavedVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SavedVideosCollectionViewCell",
            for: indexPath
        ) as? SavedVideosCollectionViewCell
        else { fatalError() }
        return cell
    }
}
