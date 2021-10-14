//
//  CameraViewController.swift
//  EasyLearn
//
//  Created by MacBook on 15.09.21.
//

import AVFoundation
import RxSwift
import UIKit

class CameraViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var shootButton: UIButton!
    @IBOutlet private var lightButton: UIButton!
    @IBOutlet private var timerButton: UIButton!
    @IBOutlet private var turnCameraButton: UIButton!
    @IBOutlet private var libraryButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var timerLabel: UILabel!
    @IBOutlet private var addToVideosButton: UIButton!

    var session: AVCaptureSession?
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()

    let shape = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")

    var timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkCameraPermission()
        bindNavigation()
        addGestureRecognizer()
        circle()
        shootButtonTapped()
    }

    private func circle() {
        let newX = view.center.x
        let newY = view.center.y + 224

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: newX, y: newY),
                                      radius: 45,
                                      startAngle: -(.pi / 2),
                                      endAngle: .pi * 2,
                                      clockwise: true)

        shape.path = circlePath.cgPath
        shape.lineWidth = 10
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.easyPurple.cgColor
        shape.strokeEnd = 0
        view.layer.addSublayer(shape)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupViews() {
        addToVideosButton.isHidden = true
        addToVideosButton.layer.cornerRadius = addToVideosButton.frame.size.width / 2
        previewLayer.frame = view.bounds
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shootButton)
        view.addSubview(lightButton)
        view.addSubview(timerButton)
        view.addSubview(turnCameraButton)
        view.addSubview(libraryButton)
        view.addSubview(backButton)
        view.addSubview(timerLabel)
        backButton.titleLabel?.text = ""
        shootButton.layer.cornerRadius = shootButton.frame.size.width / 2
        shootButton.layer.borderWidth = 8.0
        shootButton.layer.borderColor = UIColor.white.cgColor
        shootButton.backgroundColor = .clear
    }

    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func addGestureRecognizer() {
        let pressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didPressShoot))
        shootButton.addGestureRecognizer(pressGestureRecognizer)
    }

    @objc
    private func didPressShoot(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)

            shootButton.layer.borderColor = UIColor.clear.cgColor
            backButton.isHidden = true
            timerButton.isHidden = true
            animation.toValue = 1
            animation.duration = 12
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
            shape.add(animation, forKey: "animation")
        } else if recognizer.state == .ended {

            timerCounting = false
            timer.invalidate()

            shootButton.layer.borderColor = UIColor.white.cgColor
            timerButton.isHidden = false
            backButton.isHidden = false
            shape.removeAnimation(forKey: "animation")
            self.dismiss(animated: true)
        }
    }

    @objc func timerCounter() {
        count += 1
        let time = makeSeconds(seconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        timerLabel.text = timeString
    }

    func makeSeconds(seconds: Int) -> (Int, Int) {
        (((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }

    func makeTimeString(minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%0d", minutes)
        timeString += ":"
        timeString += String(format: "%02d",seconds)
        return timeString
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            })
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }

    private func setupCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session

                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }

    private func shootButtonTapped() {
        shootButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapShoot()
            })
            .disposed(by: disposeBag)
    }

    private func didTapShoot() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: data)

        session?.stopRunning()

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        view.addSubview(backButton)
        backButton.isHidden = false
        view.addSubview(addToVideosButton)
        addToVideosButton.isHidden = false
    }
}
