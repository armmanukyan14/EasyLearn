//
//  EnterEmailViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import RxSwift
import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: EnterEmailViewModel!

    // MARK: - Outlets

    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var emailErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        doBindings()
    }

    // MARK: - Methods

    private func setupViews() {
        nextButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Email", textField: emailTextField)
    }

    // MARK: - Reactive

    private func doBindings() {
        bindOutputs()
        bindInputs()
        bindNavigation()
    }

    // MARK: - Inputs

    private func bindInputs() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
    }

    // MARK: - Outputs

    private func bindOutputs() {
        viewModel.emailError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.emailErrorLabel.textColor = .easyPurple
                    self?.emailErrorLabel.text = error
                    self?.emailErrorLabel.isHidden = false
                } else {
                    self?.emailErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .withLatestFrom(viewModel.email)
            .subscribe(onNext: { [weak self] email in
                guard let self = self else { return }
                let vc = EnterConfirmationCodeViewController.getInstance(from: .signUp)
                var dependencies = self.viewModel.dependencies
                dependencies.email = email
                vc.viewModel = .init(dependencies: dependencies)
                self.navigationController?.pushViewController(vc, animated: true)
//                guard let emailToSend = self.emailTextField.text
//                else { return }
//                let auth = Auth.auth()
//                let actionCodeSettings = ActionCodeSettings()
//                actionCodeSettings.handleCodeInApp = true
//                actionCodeSettings.url = URL(string: "https://tech42.page.link/easylearn")
//
//                auth.sendSignInLink(toEmail: emailToSend,
//                                    actionCodeSettings: actionCodeSettings) { error in
//                    if let error = error {
//                        let alert = UIAlertController(title: "Error",
//                                                      message: error.localizedDescription,
//                                                      preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//                        self.present(alert, animated: true)
//                    }
//
//                    let alert = UIAlertController(title: "",
//                                                  message: "A reset password email was sent!",
//                                                  preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//                    self.present(alert, animated: true)
//                }

            })
            .disposed(by: disposeBag)

        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
