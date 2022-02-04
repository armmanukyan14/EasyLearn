//
//  SearchViewController.swift
//  EasyLearn
//
//  Created by MacBook on 24.08.21.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Properties

    private let searchController = UISearchController()

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupSearchController()
    }

    // MARK: - Methods

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.getCompositionalLayout(height: 130),
                                               animated: false)
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}

    // MARK: - Extensions

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SearchCollectionViewCell",
            for: indexPath
        ) as? SearchCollectionViewCell
        else { fatalError() }

//        let item = items[indexPath.item]
//        cell.searchVideoView.backgroundColor = item

        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text
        else { return }
        print(text)
    }
}
