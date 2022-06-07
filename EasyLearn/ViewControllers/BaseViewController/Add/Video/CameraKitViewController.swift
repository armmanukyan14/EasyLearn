//
//  CameraKitViewController.swift
//  EasyLearn
//
//  Created by MacBook on 01.02.22.
//

import CameraKit_iOS
import Firebase
import FirebaseStorage
import RxSwift
import UIKit

protocol CameraKitViewControllerDelegate: AnyObject {
    func didSaveVideo(url: URL)
}

class CameraKitViewController: UIViewController {

    var viewModel: CameraKitViewModel!

    weak var delegate: CameraKitViewControllerDelegate?

    private let disposeBag = DisposeBag()
    private let session = CKFVideoSession()

    let videos = [String]()

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        session.start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        session.stop()
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
                self?.navigationController?.popViewController(animated: true)
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

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }

    @objc private func didDoubleTap() {
        session.togglePosition()
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
                self.delegate?.didSaveVideo(url: url)
            }) { error in
                print(error.localizedDescription)
            }

            shutterButton.layer.borderColor = UIColor.clear.cgColor
            shutterButton.backgroundColor = .easyGray

            backButton.isHidden = true
            photoLibraryButton.isHidden = true

            strokeLayer.add(animation, forKey: "circleAnimation")
        case .ended:
            backButton.isHidden = false
            photoLibraryButton.isHidden = false

            shutterButton.layer.borderColor = UIColor.white.cgColor
            shutterButton.backgroundColor = .clear

            strokeLayer.removeAllAnimations()

            session.stopRecording()

            let vc = TakenVideoViewController.getInstance(from: .base)
            self.delegate = vc
            vc.viewModel = .init(dependency: self.viewModel.dependency)
            
            self.navigationController?.pushViewController(vc, animated: false)

        default: break
        }
    }

    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    var videoNumber = 0
}

extension CameraKitViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
        else { return }

        let storageRef = Storage.storage().reference()
        if let uid = Auth.auth().currentUser?.uid {
            let videosRef = storageRef.child("Taken Videos")
            let fileName = "\(uid)"
            let userVideosRef = videosRef.child(fileName)
            guard let phrase = viewModel.dependency.phrase
            else { return }
            let phraseWithoutWhiteSpace = phrase.trimmingCharacters(in: .whitespaces)
            let takenVideoRef = userVideosRef.child("\(phraseWithoutWhiteSpace)")

            takenVideoRef.putFile(from: videoURL, metadata: nil)

            let urlString = videoURL.absoluteString

            userVideos += [urlString]
        }
    }
}


func getVideosDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory.appendingPathComponent("videos")
}
