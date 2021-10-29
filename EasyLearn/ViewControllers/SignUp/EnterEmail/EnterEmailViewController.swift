//
//  EnterEmailViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import RxSwift
import UIKit

class EnterEmailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = EnterEmailViewModel()

    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var emailErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutputs()
        bindInputs()
        setupEmailTextField()
        bindNavigation()
        setupNextButton()
    }

    private func bindInputs() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
    }

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

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
    }


    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .subscribe(onNext: { [weak self] _ in
                let enterConfirmationCodeViewController = UIStoryboard.signUp.instantiateViewController(identifier: "EnterConfirmationCodeViewController")
                self?.navigationController?.pushViewController(enterConfirmationCodeViewController, animated: true)
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


private func setupEmailTextField() {
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
