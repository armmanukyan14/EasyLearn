//
//  SearchDetailViewController.swift
//  EasyLearn
//
//  Created by MacBook on 26.03.22.
//

import UIKit
import AVKit
import RxSwift

class SearchDetailViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var videoView: UIView!
    @IBOutlet private var backButton: UIButton!

    weak var playerItem: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindNavigation()

        play(player: playerItem)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        playerItem.pause()
    }

    private func setupViews() {
        videoView.layer.cornerRadius = 10
        backButton.layer.cornerRadius = backButton.frame.size.height / 2
    }

    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func play(player: AVPlayer) {
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame = videoView.bounds
        videoLayer.masksToBounds = true
        videoLayer.cornerRadius = 10.0
        videoLayer.videoGravity = .resizeAspectFill
        videoView.layer.addSublayer(videoLayer)
        player.play()
    }
}
