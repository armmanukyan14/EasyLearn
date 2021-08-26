//
//  VideosViewController.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit
import AVKit
import AVFoundation
import RxSwift

class VideosViewController: UIViewController {

    let currentPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "euro", ofType: "mp4")!))
    let nextPlayer = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "kishta", ofType: "mp4")!))

    @IBOutlet private var homeTabBarItem: UITabBarItem!
    @IBOutlet private var searchTabBarItem: UITabBarItem!
    @IBOutlet private var addTabBarItem: UITabBarItem!
    @IBOutlet private var saveTabBarItem: UITabBarItem!
    @IBOutlet private var profileTabBarItem: UITabBarItem!
    @IBOutlet private var currentVideoView: UIView!
    @IBOutlet private var nextVideoView: UIView!
    @IBOutlet private var tabBar: UITabBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupVideo()
        didAddGestureRecognizer()
    }

    private func setupVideo() {
        let currentVideoLayer = AVPlayerLayer(player: currentPlayer)
        currentVideoLayer.frame = currentVideoView.bounds
        currentVideoLayer.cornerRadius = 10.0
        currentVideoLayer.videoGravity = .resizeAspectFill
        currentVideoView.layer.addSublayer(currentVideoLayer)
        currentPlayer.play()
        let nextVideoLayer = AVPlayerLayer(player: nextPlayer)
        nextVideoLayer.frame = nextVideoView.bounds
        nextVideoLayer.cornerRadius = 10.0
        nextVideoLayer.videoGravity = .resizeAspectFill
        nextVideoView.layer.addSublayer(nextVideoLayer)
        nextPlayer.pause()
    }

    private func setupViews() {
        currentVideoView.layer.cornerRadius = 10.0
        nextVideoView.layer.cornerRadius = 10.0
        self.tabBar.tintColor = .easyPurple
    }

    private func didAddGestureRecognizer() {
        let currentPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragTheCurrentView))
        currentVideoView.addGestureRecognizer(currentPanGestureRecognizer)

        let nextPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didDragTheNextView))
        nextVideoView.addGestureRecognizer(nextPanGestureRecognizer)

        let currentPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheCurrentView))
        currentVideoView.addGestureRecognizer(currentPressGestureRecognizer)

        let nextPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheNextView))
        nextVideoView.addGestureRecognizer(nextPressGestureRecognizer)
    }

    @objc
    private func didPressTheCurrentView(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            currentPlayer.pause()
        } else if recognizer.state == .ended {
            currentPlayer.play()
        }
    }

    @objc
    private func didPressTheNextView(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            nextPlayer.pause()
        } else if recognizer.state == .ended {
            nextPlayer.play()
        }
    }

    @objc
    private func didDragTheCurrentView(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            currentPlayer.pause()
        } else if recognizer.state == .changed {

            let translation = recognizer.translation(in: self.view)
            tiltTheCurrentVideoView(with: translation)

            let newX = currentVideoView.center.x + translation.x
            let newY = currentVideoView.center.y + translation.y

            currentVideoView.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: self.view)

        } else if recognizer.state == .ended {
            currentPlayer.play()
            if currentVideoView.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.currentVideoView.center.x = -self.currentVideoView.frame.size.width
                    self.currentPlayer.pause()
                    self.nextPlayer.play()
                    self.currentVideoView.isHidden = true
                    self.currentPlayer.volume = 0
                })
            }  else if currentVideoView.center.x > self.view.frame.size.width - 30 {
                 UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.currentVideoView.center.x = self.view.frame.size.width + self.currentVideoView.frame.size.width
                    self.currentPlayer.pause()
                    self.nextPlayer.play()
                    self.currentVideoView.isHidden = true
                    self.currentPlayer.volume = 0
                })
            }

            UIView.animate(withDuration: 0, delay: 0.1, options: [], animations: {
                self.currentVideoView.transform = .identity
                self.currentVideoView.center = self.view.center
            })
        }
    }

    @objc
    private func didDragTheNextView(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            nextPlayer.pause()
        } else if recognizer.state == .changed {

            let translation = recognizer.translation(in: self.view)
            tiltTheNextVideoView(with: translation)

            let newX = nextVideoView.center.x + translation.x
            let newY = nextVideoView.center.y + translation.y

            nextVideoView.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: self.view)

        } else if recognizer.state == .ended {
            nextPlayer.play()
            if nextVideoView.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.nextVideoView.center.x = -self.nextVideoView.frame.size.width
                    self.nextPlayer.pause()
                    self.nextVideoView.isHidden = true
                    self.nextPlayer.volume = 0
                })
            } else if nextVideoView.center.x > self.view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.nextVideoView.center.x = self.view.frame.size.width + self.currentVideoView.frame.size.width
                    self.nextPlayer.pause()
                    self.nextVideoView.isHidden = true
                    self.nextPlayer.volume = 0
                })
            }

            UIView.animate(withDuration: 0, delay: 0.1, options: [], animations: {
                self.nextVideoView.transform = .identity
                self.nextVideoView.center = self.view.center
            })
        }
    }

    private func tiltTheCurrentVideoView(with translationValue: CGPoint) {
        let translationMoved = self.view.center.x - self.currentVideoView.center.x
        let tiltCorner = (self.view.frame.size.width / 2) / 0.2

        currentVideoView.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }

    private func tiltTheNextVideoView(with translation: CGPoint) {
        let translationMoved = self.view.center.x - self.nextVideoView.center.x
        let tiltCorner = (self.view.frame.size.width / 2) / 0.2

        nextVideoView.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }
}
