//
//  TakenVideoViewController.swift
//  EasyLearn
//
//  Created by MacBook on 11.03.22.
//

import AVKit
import RxSwift
import UIKit
import Firebase
import RxRelay

class TakenVideoViewController: UIViewController {
    
    var viewModel: TakenVideoViewModel!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var replayButton: UIButton!
    @IBOutlet private var downloadButton: UIButton!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var phraseLabel: UILabel!

    let vid = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindNavigation()
        setupViews()
        setupPhraseLabel()
    }
    
    private func setupPhraseLabel() {
        guard let phrase = viewModel.dependency.phrase
        else { return }
        let phraseWithoutWhiteSpace = phrase.trimmingCharacters(in: .whitespaces)
        phraseLabel.text = phraseWithoutWhiteSpace
        phraseLabel.layer.cornerRadius = 5
        phraseLabel.clipsToBounds = true
    }
    
    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        replayButton.isHidden = true
        
        [backButton, replayButton, downloadButton, playButton, saveButton].forEach {
            $0?.layer.cornerRadius = ($0?.bounds.height)! / 2
            $0?.backgroundColor = .easyPurple
            $0?.tintColor = .white
        }
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.setValue(NSAttributedString.setAlert(title: "Video was saved to camera roll"),
                       forKey: "attributedTitle")
        UIAlertController.setAlertButtonColor()
        
        present(alert, animated: true)
    }
}

extension TakenVideoViewController: CameraKitViewControllerDelegate {
    func didSaveVideo(url: URL) {
        let player = AVPlayer(url: url)
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame = view.bounds
        videoLayer.masksToBounds = true
        videoLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(videoLayer)
        videoLayer.addSublayer(backButton.layer)
        videoLayer.addSublayer(replayButton.layer)
        videoLayer.addSublayer(downloadButton.layer)
        videoLayer.addSublayer(playButton.layer)
        videoLayer.addSublayer(saveButton.layer)
        videoLayer.addSublayer(phraseLabel.layer)
        
        playButton.rx.tap
            .subscribe(onNext: { [weak self] in
                player.play()
                self?.playButton.isHidden = true
                self?.replayButton.isHidden = false
            })
            .disposed(by: disposeBag)
        
        replayButton.rx.tap
            .subscribe(onNext: {
                player.seek(to: CMTime.zero)
                player.play()
            })
            .disposed(by: disposeBag)
        
        downloadButton.rx.tap
            .subscribe(onNext: { [weak self] in
                UISaveVideoAtPathToSavedPhotosAlbum(
                    url.path,
                    self,
                    #selector(self?.video(_:didFinishSavingWithError:contextInfo:)),
                    nil)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .do(onNext: { [weak self] in
                let storageRef = Storage.storage().reference()
                if let uid = Auth.auth().currentUser?.uid {
                    let videosRef = storageRef.child("Taken Videos")
                    let fileName = "\(uid)"
                    let userVideosRef = videosRef.child(fileName)
                    guard let phrase = self?.viewModel.dependency.phrase
                    else { return }
                    let phraseWithoutWhiteSpace = phrase.trimmingCharacters(in: .whitespaces)
                    let takenVideoRef = userVideosRef.child("\(phraseWithoutWhiteSpace)")
                    
                    takenVideoRef.putFile(from: url, metadata: nil)
                    
                    let urlString = url.absoluteString

                    userVideos += [urlString]
                }
            })
                .subscribe(onNext: { [weak self] in
                    let vc = BaseViewController.getInstance(from: .base)
                    self?.navigationController?.setViewControllers([vc], animated: false)
                })
                .disposed(by: disposeBag)
                }
}
