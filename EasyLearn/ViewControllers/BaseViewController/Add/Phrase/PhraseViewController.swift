//
//  PhraseViewController.swift
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

class PhraseViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    private let viewModel = PhraseViewModel()

    @IBOutlet private var phraseTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        doBindings()
        closeKeyboardWhenTapped()
    }

    private func doBindings() {
        bindOutputs()
        bindInputs()
        openCamera()
    }

    private func bindOutputs() {
        viewModel.phraseError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.errorLabel.textColor = .easyPurple
                    self?.errorLabel.text = error
                    self?.errorLabel.isHidden = false
                } else {
                    self?.errorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindInputs() {
        phraseTextField.rx.text.orEmpty
            .bind(to: viewModel.phrase)
            .disposed(by: disposeBag)
    }

    private func openCamera() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .withLatestFrom(viewModel.phrase)
            .subscribe(onNext: { [weak self] phrase in
                let vc = CameraKitViewController.getInstance(from: .base)
                vc.viewModel = .init(dependency: .init(phrase: phrase))
                self?.navigationController?.pushViewController(vc, animated: false)
            })
            .disposed(by: disposeBag)

        phraseTextField.rx.text.orEmpty
            .bind(to: viewModel.phrase)
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        nextButton.layer.cornerRadius = 10.0
        UITextField.setupTextField(placeholder: "word / phrase", textField: phraseTextField)
    }

    private func closeKeyboardWhenTapped() {
        let tapBackground = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackground)
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
            .disposed(by: disposeBag)
    }
}

extension PhraseViewController: UIImagePickerControllerDelegate {
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

extension PhraseViewController: UINavigationControllerDelegate {}
