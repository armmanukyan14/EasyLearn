//
//  WelcomeViewController.swift
//  EasyLearn
//
//  Created by MacBook on 18.08.21.
//

import UIKit
import RxSwift

class WelcomeViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var signUpButton: UIButton!
    @IBOutlet private var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignUpButton()
        didTapSignUpButton()
    }

    private func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 10.0
    }

    private func didTapSignUpButton() {
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterNameViewController") as? EnterNameViewController {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)

        logInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

