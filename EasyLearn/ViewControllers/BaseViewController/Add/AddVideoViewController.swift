//
//  AddVideoViewController.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import AVKit
import Firebase
import MobileCoreServices
import RxSwift
import UIKit
import CameraKit_iOS

class AddVideoViewController: UIViewController {
    private let disposeBag = DisposeBag()

    @IBOutlet private var phraseTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        openCamera()
    }

    private func openCamera() {
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in

//                let picker = UIImagePickerController()
//                picker.sourceType = .camera
//                picker.mediaTypes = [kUTTypeMovie as String]
//                picker.allowsEditing = true
//                picker.delegate = self
//                self?.present(picker, animated: true)

                let vc = CameraKitViewController.getInstance(from: .base)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        nextButton.layer.cornerRadius = 10.0
        UITextField.setupTextField(placeholder: "word / phrase / sentence", textField: phraseTextField)
    }
}

extension AddVideoViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let media = info[UIImagePickerController.InfoKey.mediaURL] as? String, media == (kUTTypeMovie as String)
        else { return }

        let player = AVPlayer(url: URL(string: media)!)
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.masksToBounds = true 
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.play()
    }
}

extension AddVideoViewController: UINavigationControllerDelegate {}
