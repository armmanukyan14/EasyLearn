//
//  ProfileViewController.swift
//  EasyLearn
//
//  Created by MacBook on 14.09.21.
//

import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var editBarButtonItem: UIBarButtonItem!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindNavigation()
        setupCollectionView()

        collectionView.setCollectionViewLayout(getCompositionalLayout(height: 250), animated: false)

        collectionView.register(ProfileCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier)

    }

    // MARK: - Methods

    func getCompositionalLayout(height: CGFloat) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 6, bottom: 1, trailing: 6)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
//      section.interGroupSpacing = 10

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        // this activates the "sticky" behavior
        header.pinToVisibleBounds = true

        section.boundarySupplementaryItems = [header]


        return UICollectionViewCompositionalLayout(section: section)
    }


    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.getCompositionalLayout(height: 250),
//                                               animated: false)
    }

    private func setupViews() {
//        avatarImageView.contentMode = .scaleToFill
//        avatarImageView.layer.borderWidth = 5.0
//        avatarImageView.layer.borderColor = UIColor.easyPurple.cgColor
//        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
        navigationController?.navigationBar.tintColor = .systemBackground
    }

    // MARK: - Reactive

    private func bindNavigation() {
        editBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = EditViewController.getInstance(from: .base)
                vc.modalPresentationStyle = .fullScreen
//                vc.delegate = self
                self?.navigationController?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions

//extension ProfileViewController: EditViewControllerDelegate {
//    func didSave(user: User) {
//        avatarImageView.image = user.image
//        usernameLabel.text = user.name
//        videosCountLabel.text = String(user.videos.count)
//    }
//}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProfileCollectionViewCell",
            for: indexPath
        ) as? ProfileCollectionViewCell
        else { fatalError() }
        return cell
    }

    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {

        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileCollectionReusableView.identifier, for: indexPath) as? ProfileCollectionReusableView
        else { fatalError() }

        header.backgroundColor = .red

        return header
    }
}
