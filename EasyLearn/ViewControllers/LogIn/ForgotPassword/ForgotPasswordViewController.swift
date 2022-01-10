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
            .subscribe(onNext: {[weak self] in
                let auth = Auth.auth()

                auth.sendPasswordReset(withEmail: (self?.emailTextField.text)!) { error in
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
        sendButton.layer.cornerRadius = 10.0

        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftView = textFieldPadding
        emailTextField.leftViewMode = .always
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }
}
