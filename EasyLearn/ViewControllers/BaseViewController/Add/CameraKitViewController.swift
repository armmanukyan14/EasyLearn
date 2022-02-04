//
//  CameraKitViewController.swift
//  EasyLearn
//
//  Created by MacBook on 01.02.22.
//

import UIKit
import CameraKit_iOS
import RxSwift

class CameraKitViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var shutterButton: UIButton!
    @IBOutlet private var flashlightButton: UIButton!
    @IBOutlet private var cameraPositionButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()

        recordVideo()
        setupViews()
    }

    private func setupViews() {
        shutterButton.layer.cornerRadius = shutterButton.frame.size.height / 2
        shutterButton.layer.borderWidth = 10
        shutterButton.layer.borderColor = UIColor.easyPurple.cgColor
        flashlightButton.layer.cornerRadius = flashlightButton.frame.size.height / 2
        cameraPositionButton.layer.cornerRadius = cameraPositionButton.frame.size.height / 2
    }

    private func recordVideo() {
        let session = CKFVideoSession()
        let preview = CKFPreviewView(frame: self.view.frame)
        preview.session = session

        self.view.addSubview(preview)
        self.view.addSubview(shutterButton)
        self.view.addSubview(flashlightButton)
        self.view.addSubview(cameraPositionButton)

        shutterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                switch session.isRecording {
                case false:
                    session.record(url: URL(string: ""), { url in
                        print(url)
                    }) { error in
                        print(error.localizedDescription)
                    }
                    self?.shutterButton.backgroundColor = .clear
                    self?.shutterButton.layer.borderColor = UIColor.init(red: 190 / 255, green: 25 / 255, blue: 14 / 255, alpha: 1).cgColor
                case true:
                    session.stopRecording()
                    self?.shutterButton.backgroundColor = .clear
                    self?.shutterButton.layer.borderColor = UIColor.easyPurple.cgColor
                }
            })
            .disposed(by: disposeBag)

        flashlightButton.rx.tap
            .subscribe(onNext: {
                session.flashMode = session.flashMode == .on ? .off : .on
            })
            .disposed(by: disposeBag)

        cameraPositionButton.rx.tap
            .subscribe(onNext: {
//                session.cameraPosition = session.cameraPosition == .back ? .front : .back
                session.togglePosition()
            })
            .disposed(by: disposeBag)
    }
}
