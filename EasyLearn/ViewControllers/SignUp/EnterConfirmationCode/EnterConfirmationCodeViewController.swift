//
//  EnterConfirmationCodeViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift

class EnterConfirmationCodeViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = EnterConfirmationCodeViewModel()

    @IBOutlet private var confirmationCodeTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var codeErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutputs()
        bindInputs()
        setupViews()
        bindNavigation()
        setupNextButton()
    }

    private func bindInputs() {
        confirmationCodeTextField.rx.text.orEmpty
            .bind(to: viewModel.code)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.confirmationError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.codeErrorLabel.textColor = .easyPurple
                    self?.codeErrorLabel.text = error
                    self?.codeErrorLabel.isHidden = false
                } else {
                    self?.codeErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)    }

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
        }


    private func setupViews() {
        confirmationCodeTextField.layer.borderWidth = 1.0
        confirmationCodeTextField.layer.cornerRadius = 10.0
        confirmationCodeTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: confirmationCodeTextField.frame.height))
        confirmationCodeTextField.leftView = textFieldPadding
        confirmationCodeTextField.leftViewMode = .always
        confirmationCodeTextField.attributedPlaceholder = NSAttributedString(
            string: "Confirmation code",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .subscribe(onNext: { [weak self] _ in
                let enterPasswordViewController = UIStoryboard.signUp.instantiateViewController(identifier: "EnterPasswordViewController")
                self?.navigationController?.pushViewController(enterPasswordViewController, animated: true)
            })
            .disposed(by: disposeBag)

        confirmationCodeTextField.rx.text.orEmpty
            .bind(to: viewModel.code)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
