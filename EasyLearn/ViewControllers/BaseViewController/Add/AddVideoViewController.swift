//
//  AddVideoViewController.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import UIKit
import RxSwift
import MobileCoreServices
import AVKit
import Firebase

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
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.mediaTypes = [kUTTypeMovie as String]
                picker.allowsEditing = true
                picker.delegate = self
                self?.present(picker, animated: true)

                //                let cameraViewController = UIStoryboard.base.instantiateViewController(identifier: "CameraViewController")
                //                cameraViewController.modalPresentationStyle = .fullScreen
                //                self?.navigationController?.present(cameraViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        nextButton.layer.cornerRadius = 10.0
        phraseTextField.layer.borderWidth = 1.0
        phraseTextField.layer.cornerRadius = 10.0
        phraseTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: phraseTextField.frame.height))
        phraseTextField.leftView = textFieldPadding
        phraseTextField.leftViewMode = .always
        phraseTextField.attributedPlaceholder = NSAttributedString(
            string: "word / phrase / sentence",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
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

extension AddVideoViewController: UINavigationControllerDelegate {

}
