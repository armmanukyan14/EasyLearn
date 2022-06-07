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

    weak var playerItem: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        addGestureRecognizers()

        play(player: playerItem)
    }

    private func addGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragVideoView))
        videoView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func didDragVideoView(recognizer: UIPanGestureRecognizer) {

        if recognizer.state == .changed {

            let translation = recognizer.translation(in: self.view)

            let newX = videoView.center.x + translation.x
            let newY = videoView.center.y + translation.y

            videoView.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(.zero, in: self.view)

//            if videoView.center.y > 450 || videoView.center.y < 200 {
//                view.alpha = 0.1
//                view.backgroundColor = .clear
//            } else {
//                view.alpha = 1
//                view.backgroundColor = .systemBackground
//            }

        } else if recognizer.state == .ended {
            if videoView.center.y > 450 || videoView.center.y < 200 {
                self.dismiss(animated: false)
                videoView.isHidden = true
            } else {
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                    self.videoView.center = self.view.center
                })
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        playerItem.pause()
    }

    private func setupViews() {
        videoView.layer.cornerRadius = 10
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
