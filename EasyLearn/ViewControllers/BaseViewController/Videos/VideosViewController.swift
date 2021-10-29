//
//  VideosViewController.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import AVFoundation
import AVKit
import UIKit
import FirebaseStorage
import FirebaseAuth

class VideosViewController: UIViewController {
    let player1 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "treeAndGrass", ofType: "mp4")!))
    let player2 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "takeAndPut", ofType: "mp4")!))
    let player3 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "carDrive", ofType: "mp4")!))
    let player4 = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "cutPaper", ofType: "mp4")!))

    @IBOutlet private var videoView1: UIView!
    @IBOutlet private var videoView2: UIView!
    @IBOutlet private var videoView3: UIView!
    @IBOutlet private var videoView4: UIView!
    @IBOutlet private var redView: UIView!
    @IBOutlet private var greenView: UIView!
    @IBOutlet private var okLabel: UILabel!
    @IBOutlet private var laterLabel: UILabel!
    @IBOutlet private var phraseLabel: UILabel!
    @IBOutlet private var saveVideoButton: UIButton!

    let storageReference = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        didAddGestureRecognizer()
        addSubViews()
//        didReplayVideo()

        uploadTestVideo()
    }

    private func uploadTestVideo() {
        Auth.auth().signIn(withEmail: "armmanukyan2214@gmail.com", password: "katlet") { [weak self] result, error in
            let treeAndGrassReference = self?.storageReference.child("videos/treeAndGrass.mp4")
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "treeAndGrass", ofType: "mp4")!)
            guard let file = try? Data(contentsOf: url) else { return }

            treeAndGrassReference?.putData(file, metadata: nil) { _, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Successfully uploaded")
                    treeAndGrassReference?.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if let data = data {
                            print("Successfully downloaded")
                        }
                    }.resume()
                }
            }.resume()
        }

        let randomID = UUID().uuidString
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
        okLabel.alpha = 0
        laterLabel.alpha = 0
        okLabel.layer.cornerRadius = 10.0
        okLabel.layer.masksToBounds = true
        laterLabel.layer.cornerRadius = 10.0
<<<<<<< HEAD
        laterLabel.layer.masksToBounds = true
=======
        laterLabel.layer.masksToBounds  = true
        phraseLabel.layer.cornerRadius = 10.0
        phraseLabel.layer.masksToBounds  = true
        phraseLabel.layer.borderWidth = 1
        phraseLabel.layer.borderColor = UIColor.systemBackground.cgColor
>>>>>>> esiminch
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
        videoView3.layer.cornerRadius = 10.0
        videoView4.layer.cornerRadius = 10.0
    }

    private func setupVideoLayers() {
        let videoLayer1 = AVPlayerLayer(player: player1)
        videoLayer1.frame = videoView1.bounds
        videoLayer1.masksToBounds = true
        videoLayer1.cornerRadius = 10.0
        videoLayer1.videoGravity = .resizeAspectFill
        videoView1.layer.addSublayer(videoLayer1)
        player1.play()
        let videoLayer2 = AVPlayerLayer(player: player2)
        videoLayer2.frame = videoView2.bounds
        videoLayer2.masksToBounds = true
        videoLayer2.cornerRadius = 10.0
        videoLayer2.videoGravity = .resizeAspectFill
        videoView2.layer.addSublayer(videoLayer2)
        player2.pause()
        let videoLayer3 = AVPlayerLayer(player: player3)
        videoLayer3.frame = videoView3.bounds
        videoLayer3.masksToBounds = true
        videoLayer3.cornerRadius = 10.0
        videoLayer3.videoGravity = .resizeAspectFill
        videoView3.layer.addSublayer(videoLayer3)
        player3.pause()
        let videoLayer4 = AVPlayerLayer(player: player4)
        videoLayer4.frame = videoView4.bounds
        videoLayer4.masksToBounds = true
        videoLayer4.cornerRadius = 10.0
        videoLayer4.videoGravity = .resizeAspectFill
        videoView4.layer.addSublayer(videoLayer4)
        player4.pause()
    }

    private func didAddGestureRecognizer() {
        let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector(didDragTheCurrentView))
        videoView1.addGestureRecognizer(panGestureRecognizer1)

        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector(didDragTheNextView))
        videoView2.addGestureRecognizer(panGestureRecognizer2)

        let panGestureRecognizer3 = UIPanGestureRecognizer(target: self, action: #selector(didDragView3))
        videoView3.addGestureRecognizer(panGestureRecognizer3)

        let panGestureRecognizer4 = UIPanGestureRecognizer(target: self, action: #selector(didDragView4))
        videoView4.addGestureRecognizer(panGestureRecognizer4)

        let pressGestureRecognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheCurrentView))
        videoView1.addGestureRecognizer(pressGestureRecognizer1)

        let pressGestureRecognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(didPressTheNextView))
        videoView2.addGestureRecognizer(pressGestureRecognizer2)

        let pressGestureRecognizer3 = UILongPressGestureRecognizer(target: self, action: #selector(didPressView3))
        videoView3.addGestureRecognizer(pressGestureRecognizer3)

        let pressGestureRecognizer4 = UILongPressGestureRecognizer(target: self, action: #selector(didPressView4))
        videoView4.addGestureRecognizer(pressGestureRecognizer4)
    }

    private func didReplayVideo() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(video4DidEnd),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    @objc func video4DidEnd(notification: NSNotification) {
        player4.seek(to: CMTime.zero)
        player4.play()
    }

    @objc
    private func didPressTheCurrentView(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            player1.pause()
        } else if recognizer.state == .ended {
            player1.play()
        }
    }

    @objc
    private func didPressTheNextView(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            player2.pause()
        } else if recognizer.state == .ended {
            player2.play()
        }
    }

    @objc
    private func didPressView3(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            player3.pause()
        } else if recognizer.state == .ended {
            player3.play()
        }
    }

    @objc
    private func didPressView4(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            player4.pause()
        } else if recognizer.state == .ended {
            player4.play()
        }
    }

    @objc
    private func didDragTheCurrentView(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            player1.pause()

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
            player1.play()

            if videoView1.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView1.center.x = -self.videoView1.frame.size.width
                    self.player1.pause()
                    self.player2.play()
                    self.videoView1.isHidden = true
                    self.player1.volume = 0
                })
            } else if videoView1.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView1.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.player1.pause()
                    self.player2.play()
                    self.videoView1.isHidden = true
                    self.player1.volume = 0
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
            player2.pause()
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
            player2.play()
            if videoView2.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView2.center.x = -self.videoView2.frame.size.width
                    self.player2.pause()
                    self.player3.play()
                    self.videoView2.isHidden = true
                    self.player2.volume = 0
                })
            } else if videoView2.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView2.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.player2.pause()
                    self.player3.play()
                    self.videoView2.isHidden = true
                    self.player2.volume = 0
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

    @objc
    private func didDragView3(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            player3.pause()
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            tiltVideoView3(with: translation)

            let newX = videoView3.center.x + translation.x
            let newY = videoView3.center.y + translation.y

            videoView3.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: view)

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0.75
                self.greenView.alpha = 0.75
            })

        } else if recognizer.state == .ended {
            player3.play()
            if videoView3.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView3.center.x = -self.videoView3.frame.size.width
                    self.player3.pause()
                    self.player4.play()
                    self.videoView3.isHidden = true
                    self.player3.volume = 0
                })
            } else if videoView3.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView3.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.player3.pause()
                    self.player4.play()
                    self.videoView3.isHidden = true
                    self.player3.volume = 0
                })
            }

            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.videoView3.transform = .identity
                self.videoView3.center = self.view.center
            })

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0
                self.greenView.alpha = 0
            })
        }
    }

    @objc
    private func didDragView4(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .began {
            player4.pause()
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: view)
            tiltVideoView4(with: translation)

            let newX = videoView4.center.x + translation.x
            let newY = videoView4.center.y + translation.y

            videoView4.center = CGPoint(x: newX, y: newY)
            recognizer.setTranslation(CGPoint.zero, in: view)

            UIView.animate(withDuration: 1, animations: {
                self.redView.alpha = 0.75
                self.greenView.alpha = 0.75
            })

        } else if recognizer.state == .ended {
            player4.play()
            if videoView4.center.x < 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView4.center.x = -self.videoView4.frame.size.width
                    self.player4.pause()
                    self.videoView4.isHidden = true
                    self.player4.volume = 0
                })
            } else if videoView4.center.x > view.frame.size.width - 30 {
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.videoView4.center.x = self.view.frame.size.width + self.videoView1.frame.size.width
                    self.player4.pause()
                    self.videoView4.isHidden = true
                    self.player4.volume = 0
                })
            }

            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
                self.videoView4.transform = .identity
                self.videoView4.center = self.view.center
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

    private func tiltVideoView3(with translation: CGPoint) {
        let translationMoved = view.center.x - videoView3.center.x
        let tiltCorner = (view.frame.size.width / 2) / 0.2

        videoView3.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }

    private func tiltVideoView4(with translation: CGPoint) {
        let translationMoved = view.center.x - videoView4.center.x
        let tiltCorner = (view.frame.size.width / 2) / 0.2

        videoView4.transform = CGAffineTransform(rotationAngle: translationMoved / tiltCorner)
    }
}
