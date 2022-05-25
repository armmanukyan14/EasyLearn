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
                auth.sendPasswordReset(withEmail: emailToSend) { [weak self] error in
                    if let error = error {
                        self?.showAlert(title: error.localizedDescription)
                    }
                    self?.showAlert(title: "A reset password email was sent!")
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func showAlert(title: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.setValue(NSAttributedString.setAlert(title: title),
                       forKey: "attributedTitle")
        UIAlertController.setAlertButtonColor()

        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    private func setupViews() {
        sendButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Email", textField: emailTextField)
    }
}
