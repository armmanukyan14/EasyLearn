//
//  CameraKitViewController.swift
//  EasyLearn
//
//  Created by MacBook on 01.02.22.
//

import CameraKit_iOS
import RxSwift
import UIKit

class CameraKitViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let session = CKFVideoSession()

    @IBOutlet private var shutterButton: UIButton!
    @IBOutlet private var flashlightButton: UIButton!
    @IBOutlet private var cameraPositionButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var photoLibraryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        addCameraPreview()
        setupViews()
        bindNavigation()
        addSubviews()
        openPhotoLibrary()
        changeCameraPosition()
        toggleFlashlight()
        pressShutterButton()
    }

    private func setupViews() {
        shutterButton.layer.cornerRadius = shutterButton.bounds.size.height / 2
        shutterButton.backgroundColor = .clear
        shutterButton.layer.borderWidth = 10
        shutterButton.layer.borderColor = UIColor.white.cgColor
        flashlightButton.layer.cornerRadius = flashlightButton.frame.size.height / 2
        cameraPositionButton.layer.cornerRadius = cameraPositionButton.frame.size.height / 2
        backButton.backgroundColor = UIColor.easyGray
        backButton.layer.cornerRadius = backButton.frame.size.height / 2
    }

    private func addSubviews() {
        view.addSubview(shutterButton)
        view.addSubview(flashlightButton)
        view.addSubview(cameraPositionButton)
        view.addSubview(backButton)
        view.addSubview(photoLibraryButton)
    }

    private func addCameraPreview() {
        let preview = CKFPreviewView(frame: view.frame)
        preview.session = session
        view.addSubview(preview)
    }

    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func changeCameraPosition() {
        cameraPositionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.session.togglePosition()
                if self?.session.cameraPosition == .back {
                    self?.flashlightButton.isHidden = false
                } else if self?.session.cameraPosition == .front {
                    self?.flashlightButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    private func toggleFlashlight() {
        flashlightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.session.flashMode = self?.session.flashMode == .on ? .off : .on
            })
            .disposed(by: disposeBag)
    }

    private func openPhotoLibrary() {
        photoLibraryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                picker.mediaTypes = ["public.movie"]
                picker.delegate = self
                picker.modalPresentationStyle = .fullScreen
                self?.present(picker, animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func pressShutterButton() {
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressShutterButton))
        shutterButton.addGestureRecognizer(pressGesture)
    }

    @objc private func didPressShutterButton(recognizer: UILongPressGestureRecognizer) {
        let strokeLayer = CAShapeLayer()
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.strokeColor = UIColor.easyPurple.cgColor
        strokeLayer.lineWidth = 20
        strokeLayer.strokeEnd = 0

        strokeLayer.path = UIBezierPath(
            arcCenter: .init(x: shutterButton.bounds.width / 2, y: shutterButton.bounds.height / 2),
            radius: shutterButton.frame.width / 2,
            startAngle: -(.pi / 2),
            endAngle: 1.5 * .pi,
            clockwise: true
        ).cgPath

        shutterButton.layer.addSublayer(strokeLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        switch recognizer.state {
        case .began:
            session.record(url: URL(string: ""), { url in
                print(url)
            }) { error in
                print(error.localizedDescription)
            }

            shutterButton.layer.borderColor = UIColor.clear.cgColor
            shutterButton.backgroundColor = .easyGray
            strokeLayer.add(animation, forKey: "circleAnimation")
        case .ended:
            shutterButton.layer.borderColor = UIColor.white.cgColor
            shutterButton.backgroundColor = .clear
            strokeLayer.removeAllAnimations()

            session.stopRecording()
        default: break
        }
    }
}

extension CameraKitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
    }
}
