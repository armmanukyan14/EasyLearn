//
//  ForgotPasswordViewController.swift
//  EasyLearn
//
//  Created by MacBook on 06.10.21.
//

import UIKit
import RxSwift
import Firebase

class ForgotPasswordViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindNavigation()
    }

    private func bindNavigation() {
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let emailToSend = self?.emailTextField.text
                else { return }
                let auth = Auth.auth()
                auth.sendPasswordReset(withEmail: emailToSend) { error in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                        self?.present(alert, animated: true)
                    }

                    let alert = UIAlertController(title: "", message: "A reset password email was sent!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self?.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        sendButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Email", textField: emailTextField)
    }
}
