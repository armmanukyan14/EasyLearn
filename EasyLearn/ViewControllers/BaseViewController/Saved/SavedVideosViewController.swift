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
        refreshCollectionView()
    }

    // MARK: - Methods
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.getCompositionalLayout(height: 150),
                                               animated: false)
    }

    private func refreshCollectionView() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }

    @objc
    private func pullToRefresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
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
