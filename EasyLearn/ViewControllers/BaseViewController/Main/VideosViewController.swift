//
//  VideosViewController.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import AVFoundation
import AVKit
import Firebase
import FirebaseStorage
import RxSwift
import UIKit

class VideosViewController: UIViewController {
    let player1 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "treeAndGrass", ofType: "mp4")!))
    let player2 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "takeAndPut", ofType: "mp4")!))
    let player3 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "carDrive", ofType: "mp4")!))
    let player4 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "cutPaper", ofType: "mp4")!))

    lazy var players = [player1, player2, player3, player4]

    lazy var currentPlayer = players[.random(in: 0..<players.count)]
    lazy var nextPlayer = players[.random(in: 0..<players.count)]

    @IBOutlet private var videoView1: UIView!
    @IBOutlet private var videoView2: UIView!
    @IBOutlet private var redView: UIView!
    @IBOutlet private var greenView: UIView!
    @IBOutlet private var okLabel: UILabel!
    @IBOutlet private var laterLabel: UILabel!
    @IBOutlet private var phraseLabel: UILabel!
    @IBOutlet private var saveVideoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        didAddGestureRecognizer()
        addSubViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        players.forEach { $0.pause() }

        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //        setupVideoLayers()

        //        registerForNotification()

        //        currentPlayer.seek(to: .zero)
        //        currentPlayer.play()

        if videoView1.isHidden == true {
            nextPlayer.seek(to: .zero)
            nextPlayer.play()
        } else {
            nextPlayer.pause()
        }
    }

    private func addSubViews() {
        videoView1.addSubview(okLabel)
        videoView1.addSubview(laterLabel)
        videoView1.addSubview(phraseLabel)
        videoView1.addSubview(saveVideoButton)
    }

    private func setupViews() {
        setupLabels()
        setupRedAndGreenViews()
        setupVideoViews()
        setupVideoLayers()
    }

    private func setupLabels() {
        [okLabel, laterLabel, phraseLabel].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        }
        okLabel.alpha = 0
        laterLabel.alpha = 0
        phraseLabel.layer.borderWidth = 1
        phraseLabel.layer.borderColor = UIColor.systemBackground.cgColor
    }

    private func setupRedAndGreenViews() {
        redView.alpha = 0
        greenView.alpha = 0
        redView.layer.cornerRadius = 30
        redView.backgroundColor = .redViewColor
        greenView.layer.cornerRadius = 30
        greenView.backgroundColor = .greenViewColor
    }

    private func setupVideoViews() {
        videoView1.layer.cornerRadius = 10.0
        videoView2.layer.cornerRadius = 10.0
    }

    private func setupVideoLayers() {
        let videoLayer1 = AVPlayerLayer(player: currentPlayer)
        videoLayer1.frame = videoView1.bounds
        videoLayer1.masksToBounds = true
        videoLayer1.cornerRadius = 10.0
        videoLayer1.videoGravity = .resizeAspectFill
        videoView1.layer.addSublayer(videoLayer1)
        currentPlayer.play()

        let videoLayer2 = AVPlayerLayer(player: nextPlayer)
        videoLayer2.frame = videoView2.bounds
        videoLayer2.masksToBounds = true
        videoLayer2.cornerRadius = 10.0
        videoLayer2.videoGravity = .resizeAspectFill
        videoView2.layer.addSublayer(videoLayer2)
        nextPlayer.pause()
    }

    private func didAddGestureRecognizer() {
        let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(didDragTheCurrentView))
        videoView1.addGestureRecognizer(panGestureRecognizer1)

        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(didDragTheNextView))
        videoView2.addGestureRecognizer(panGestureRecognizer2)

        let pressGestureRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheCurrentView))
        videoView1.addGestureRecognizer(pressGestureRecognizer1)

        let pressGestureRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheNextView))
        videoView2.addGestureRecognizer(pressGestureRecognizer2)
    }

    private func registerForNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(video4DidEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    @objc func video4DidEnd() {
        player4.seek(to: CMTime.zero)
        player4.play()
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
            if videoView1.center.x < 120 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.laterLabel.alpha = 0.65
                })
            } else if videoView1.center.x > view.frame.size.width - 120 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.okLabel.alpha = 0.65
                })
            } else {
                UIView.animate(withDuration: 1, animations: {
                    self.laterLabel.alpha = 0
                    self.okLabel.alpha = 0
                })
            }

            let translation = recognizer.translation(in: view)
            tiltVideoView1(with: translation)

            let newX = videoView1.center.x + translation.x
            let newY = videoView1.center.y + translation.y

            videoView1.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: view)

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0.75
                self.greenView.alpha = 0.75
            })

        } else if recognizer.state == .ended {
            currentPlayer.play()

            if videoView1.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView1.center.x = -self.videoView1.frame.size.width
                    self.currentPlayer.pause()
                    self.nextPlayer.play()
                    self.videoView1.isHidden = true
                    self.videoView2.isHidden = false
                })
            } else if videoView1.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView1.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.currentPlayer.pause()
                    self.nextPlayer.play()
                    self.videoView1.isHidden = true
                    self.videoView2.isHidden = false
                })
            }

            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.videoView1.transform = .identity
                self.videoView1.center = self.view.center
            })

            UIView.animate(withDuration: 1, animations: {
                self.laterLabel.alpha = 0
                self.okLabel.alpha = 0
                self.greenView.alpha = 0
                self.redView.alpha = 0
            })
        }
    }

    @objc
    private func didDragTheNextView(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            nextPlayer.pause()
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            tiltVideoView2(with: translation)

            let newX = videoView2.center.x + translation.x
            let newY = videoView2.center.y + translation.y

            videoView2.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: view)

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0.75
                self.greenView.alpha = 0.75
            })

        } else if recognizer.state == .ended {
            nextPlayer.play()
            if videoView2.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView2.center.x = -self.videoView2.frame.size.width
                    self.nextPlayer.pause()
                    self.currentPlayer.play()
                    self.videoView2.isHidden = true
                    self.videoView1.isHidden = false
                })
            } else if videoView2.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView2.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.nextPlayer.pause()
                    self.currentPlayer.play()
                    self.videoView2.isHidden = true
                    self.videoView1.isHidden = false
                })
            }

            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.videoView2.transform = .identity
                self.videoView2.center = self.view.center
            })

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0
                self.greenView.alpha = 0
            })
        }
    }

    private func tiltVideoView1(with translationValue: CGPoint) {
        let translationMoved = view.center.x - videoView1.center.x
        let tiltCorner = (view.frame.size.width / 2) / 0.2

        videoView1.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }

    private func tiltVideoView2(with translation: CGPoint) {
        let translationMoved = view.center.x - videoView2.center.x
        let tiltCorner = (view.frame.size.width / 2) / 0.2

        videoView2.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }
}
