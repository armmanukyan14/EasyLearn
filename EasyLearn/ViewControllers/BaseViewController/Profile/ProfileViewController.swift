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
import Kingfisher
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
                //                vc.delegate = self
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
            //           let url = UserDefaults.standard.value(forKey: uid)
            //            let avatarImageView = header.avatarImageView
            //            let placeholderImage = UIImage(named: "addPhoto")
            //            avatarImageView.kf.setImage(with: url, placeholder: placeholderImage)
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
        
        
        //        if let urlString = UserDefaults.standard.value(forKey: "imageUrl") as? String,
        //           let url = URL(string: urlString) {
        //            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
        //                guard let data = data, error == nil
        //                else { return }
        //
        //                DispatchQueue.main.async {
        //                    let image = UIImage(data: data) ?? UIImage(named: "addPhoto")
        //                    header.set(avatarImage: image)
        //                    self.titleView.set(avatarIcon: image)
        //                }
        //            })
        //            task.resume()
        //        }
        
        header.set(videosCount: "0\nVideos")
        
        return header
    }
}

// MARK: - Extensions

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        1
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
            let takenVideoRef = userVideosRef.child("1")
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            
            
//            if let urlString = UserDefaults.standard.value(forKey: uid) as? String,
//               let url = URL(string: urlString) {
                takenVideoRef.write(toFile: documentsDirectory) { url, error in
                    if let url = url, error == nil {
                        let player = AVPlayer(url: url)
                        let players = [player]
                        
                        let playerItem = players[indexPath.item]

                        let videoLayer = AVPlayerLayer(player: playerItem)
                        videoLayer.frame = cell.bounds
                        videoLayer.masksToBounds = true
                        videoLayer.cornerRadius = 10.0
                        videoLayer.videoGravity = .resizeAspectFill
                        cell.layer.addSublayer(videoLayer)
                        playerItem.pause()
                        print("must play")
                    }
                }.resume()
//            }
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
