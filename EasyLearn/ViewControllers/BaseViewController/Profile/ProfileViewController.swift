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
    let titleView = ProfileTitleView()

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var editBarButtonItem: UIBarButtonItem!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindNavigation()
        setupCollectionView()

        titleView.isHidden = true

//        let offset = collectionView.contentOffset
//        let center = collectionView.center
//        if offset == center {
//            titleView.isHidden = false
//        } else {
//            titleView.isHidden = true
//        }


//        scrolling(collectionView)


//        let visible = collectionView.visibleSupplementaryViews(ofKind: ProfileCollectionViewHeader.kind)
//
//        if visible.count == 0 {
//            titleView.isHidden = false
//        } else {
//            titleView.isHidden = true
//        }

//        collectionView.scrollToItem(at: , at: .top, animated: true)

        navigationItem.titleView = titleView
    }

//    func scrolling(_ collectionView: UICollectionView) {
//        let height = collectionView.frame.size.height
//        let offset = collectionView.contentOffset.y
//        let distanceFromBottom = collectionView.contentSize.height - offset
//        if distanceFromBottom < height {
//            titleView.isHidden = false
//        } else {
//            titleView.isHidden = true
//        }
//    }

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
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: ProfileCollectionViewHeader.kind,
            withReuseIdentifier: ProfileCollectionViewHeader.reuseIdentifier,
            for: indexPath
        ) as? ProfileCollectionViewHeader
        else { fatalError() }

        header.set(username: "robert")

        if let urlString = UserDefaults.standard.value(forKey: "imageUrl") as? String,
           let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
                guard let data = data, error == nil
                else { return }

                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    header.set(avatarImage: image)
                    self.titleView.set(avatarIcon: image)
//                    self.collectionView.reloadData()
//                    self.collectionView.reloadItems(at: [indexPath])
                }
            })
            task.resume()
        }

        header.set(videosCount: "0\nVideos")

        return header
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

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        self.titleView.isHidden = false
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        self.titleView.isHidden = true
    }
}

//extension ProfileViewController: UIScrollViewDelegate {

//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if self.collectionView.contentInset.top < -50 {
//            self.titleView.isHidden = false
//        } else {
//            self.titleView.isHidden = true
//        }
//    }
//}

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
