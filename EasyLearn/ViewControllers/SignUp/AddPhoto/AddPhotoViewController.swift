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

    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var addPhotoButton: UIButton!
    @IBOutlet private var skipButton: UIButton!
    @IBOutlet private var avatarImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindNavigation()
        setupViews()
    }

    private func setupViews() {
        addPhotoButton.layer.cornerRadius = 10.0
    }

    private func bindNavigation() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterPasswordViewController") as? EnterPasswordViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)

        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

}
