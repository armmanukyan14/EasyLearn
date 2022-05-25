//
//  SearchViewController.swift
//  EasyLearn
//
//  Created by MacBook on 24.08.21.
//

import AVKit
import UIKit
import RxSwift

protocol SearchViewControllerDelegate: AnyObject {
    func didShowVideo(player: AVPlayer)
}

class SearchViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()

    private let searchController = UISearchController()

    private let player1 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "treeAndGrass", ofType: "mp4")!))
    private let player2 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "takeAndPut", ofType: "mp4")!))
    private let player3 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "carDrive", ofType: "mp4")!))
    private let player4 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "cutPaper", ofType: "mp4")!))

    private lazy var players = [player1, player2, player3, player4]

    // MARK: - Outlets

    @IBOutlet private var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupSearchController()
        refreshCollectionView()
        collectionViewItemSelected()
//        didReplayVideo()
//        turnOffVolume()
        
//        if NetworkMonitor.shared.isConnected {
//            print("Satisfied")
//        } else {
//            print("Unsatisfied")
//        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        players.forEach { player in
//            player.pause()
//        }
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        players.forEach { player in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
//    }

    // MARK: - Methods

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout.getCompositionalLayout(height: 150),
                                               animated: false)
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
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

//
//    private func didReplayVideo() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(videoDidEnd),
//            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//            object: nil
//        )
//    }

//    @objc func videoDidEnd() {
//        players.forEach { player in
//            player.seek(to: CMTime.zero)
//            player.play()
//        }
//    }

//    private func turnOffVolume() {
//        players.forEach { player in
//            player.volume = 0
//        }
//    }

    private func collectionViewItemSelected() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in

                guard let playerItem = self?.players[indexPath.item]
                else { return }

                let vc = SearchDetailViewController.getInstance(from: .base)
                vc.modalPresentationStyle = .fullScreen
                vc.playerItem = playerItem
                self?.navigationController?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Extensions

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        players.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "SearchCollectionViewCell",
            for: indexPath
        ) as? SearchCollectionViewCell
        else { fatalError() }

//        let playerItem = players[.random(in: 0...players.count - 1)]
        let playerItem = players[indexPath.item]

        let videoLayer = AVPlayerLayer(player: playerItem)
        videoLayer.frame = cell.bounds
        videoLayer.masksToBounds = true
        videoLayer.cornerRadius = 10.0
        videoLayer.videoGravity = .resizeAspectFill
        cell.layer.addSublayer(videoLayer)
        playerItem.pause()

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
