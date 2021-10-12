//
//  AddPhotoViewController.swift
//  EasyLearn
//
//  Created by MacBook on 26.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class AddPhotoViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let addedPhotoViewController = AddedPhotoViewController()
    public var completionCandler: ((UIImage?) -> Void)?

    @IBOutlet private var addPhotoButton: UIButton!
    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigation()
        setupViews()
    }

    private func setupViews() {
        addPhotoButton.layer.cornerRadius = 10.0
        avatarImageView.layer.cornerRadius = avatarImageView.layer.frame.height / 2
    }

    private func bindNavigation() {
        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let loginViewController = UIStoryboard.logIn.instantiateViewController(identifier: "LoginViewController")
                    self?.navigationController?.pushViewController(loginViewController, animated: true)
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        addPhotoButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let addedPhotoViewController = UIStoryboard.signUp.instantiateViewController(identifier: "AddedPhotoViewController")
                    self?.navigationController?.pushViewController(addedPhotoViewController, animated: false)
            })
            .disposed(by: disposeBag)
    }
}


