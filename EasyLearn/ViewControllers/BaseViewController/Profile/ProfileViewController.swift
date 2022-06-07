//
//  ProfileViewController.swift
//  EasyLearn
//
//  Created by MacBook on 14.09.21.
//

import RxSwift
import UIKit
import AVKit
import Firebase
//import Kingfisher
//import Network

class ProfileViewController: UIViewController {
    
    //    let monitor = NWPathMonitor()
    
    //    var players = [AVPlayer]()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let titleView = ProfileTitleView()
    
    var viewController: UIViewController?
    
    let storage = Storage.storage().reference()
    
    // MARK: - Outlets
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var editBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindNavigation()
        setupCollectionView()
        refreshCollectionView()
        self.tabBarController?.delegate = self
        
        //        monitor.pathUpdateHandler = { [weak self] path in
        //            if path.status == .satisfied {
        //                print("We're connected!")
        //            } else {
        //                let vc = NoInternetViewController.getInstance(from: .noInternet)
        //                vc.modalPresentationStyle = .fullScreen
        //                self?.navigationController?.present(vc, animated: false)
        //            }
        //        }
        //        let queue = DispatchQueue.main
        //        monitor.start(queue: queue)
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
        titleView.isHidden = true
        navigationItem.titleView = titleView
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func refreshCollectionView() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(pullToRefresh),
                                                 for: .valueChanged)
    }
    
    @objc
    private func pullToRefresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Reactive
    
    private func bindNavigation() {
        editBarButtonItem.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = EditViewController.getInstance(from: .base)
                vc.modalPresentationStyle = .fullScreen
                //                                vc.delegate = self
                self?.navigationController?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: ProfileCollectionViewHeader.kind,
            withReuseIdentifier: ProfileCollectionViewHeader.reuseIdentifier,
            for: indexPath
        ) as? ProfileCollectionViewHeader
        else { fatalError() }
        
        titleView.set(username: Auth.auth().currentUser?.displayName)
        header.set(username: Auth.auth().currentUser?.displayName)
        
        let imagesRef = storage.child("images")
        
        if let uid = Auth.auth().currentUser?.uid {
            let imageRef = imagesRef.child(uid)
            
            imageRef.getData(maxSize: 1 * 2048 * 2048) { [weak self] data, error in
                if let data = data, error == nil {
                    let image = UIImage(data: data)
                    header.set(avatarImage: image)
                    self?.titleView.avatarIconImageView.image = image
                } else {
                    let image = UIImage(named: "addPhoto")
                    header.set(avatarImage: image)
                    self?.titleView.avatarIconImageView.image = image
                }
            }
        }
        
        header.set(videosCount: "0\nVideos")
        
        return header
    }
}

// MARK: - Extensions

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        userVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ProfileCollectionViewCell",
            for: indexPath
        ) as? ProfileCollectionViewCell
        else { fatalError() }

                if let uid = Auth.auth().currentUser?.uid {
                    let videosRef = storage.child("Taken Videos")
                    let fileName = "\(uid)"
                    let userVideosRef = videosRef.child(fileName)
                    userVideosRef.listAll { result, error in
                        if error == nil {
                            if let url = URL(string: userVideos[indexPath.item]) {
                                let urls = userVideos[0...userVideos.count - 1]
                                result.items.forEach { $0.write(toFile: url) { url, error in
                                    if let playerUrl = URL(string: urls[indexPath.item]),
                                       error == nil {

                                        let players = [AVPlayer(url: playerUrl)]

                                        let player = players[indexPath.item]

                                        let videoLayer = AVPlayerLayer(player: player)
                                        videoLayer.frame = cell.bounds
                                        videoLayer.masksToBounds = true
                                        videoLayer.cornerRadius = 10.0
                                        videoLayer.videoGravity = .resizeAspectFill
                                        cell.layer.addSublayer(videoLayer)
                                        player.play()
                                        print("must play")
                                    }
                                }.resume()
                                }
                            }
                        }
                    }
                    return cell
                } else {
                    return cell
                }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String,
                        at indexPath: IndexPath) {
        titleView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplaySupplementaryView view: UICollectionReusableView,
                        forElementKind elementKind: String,
                        at indexPath: IndexPath) {
        titleView.isHidden = true
    }
}

extension ProfileViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        self.viewController = viewController
        
        guard self.viewController == viewController
        else { return }
        guard let navVC = viewController as? UINavigationController,
              let vc = navVC.viewControllers.first as? ProfileViewController
        else { return }
        if vc.isViewLoaded && vc.view.window != nil {
            vc.collectionView.setContentOffset(.zero, animated: true)
        }
    }
}


