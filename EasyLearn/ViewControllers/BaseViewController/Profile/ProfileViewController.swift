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
    }

    // MARK: - Methods

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.getCompositionalLayoutWithHeader(height: 250),
            animated: false
        )

        collectionView.register(ProfileCollectionViewHeader.self,
                                forSupplementaryViewOfKind: ProfileCollectionViewHeader.kind,
                                withReuseIdentifier: ProfileCollectionViewHeader.reuseIdentifier)
    }

    private func setupViews() {
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: ProfileCollectionViewHeader.kind,
            withReuseIdentifier: ProfileCollectionViewHeader.reuseIdentifier,
            for: indexPath
        ) as? ProfileCollectionViewHeader
        else { fatalError() }

        view.set(username: "robert")
        view.set(avatarImage: UIImage(named: "BU"))
        view.set(videosCount: "0 \n Videos")

        return view
    }
}

// MARK: - Extensions

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
}

// extension ProfileViewController: EditViewControllerDelegate {
//   func didSave(user: User) {
//       let view = ProfileCollectionViewHeader()
//       view.set(username: user.name)
//       view.set(avatarImage: user.image)
//       view.set(videosCount: String(user.videos.count))

//       avatarImageView.image = user.image
//       usernameLabel.text = user.name
//       videosCountLabel.text = String(user.videos.count)
//   }
// }
