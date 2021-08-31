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
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var codeErrorLabel: UILabel!

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
            .bind(to: viewModel.confirmationText)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.confirmationError.skip(2)
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.codeErrorLabel.text = error
                    self?.codeErrorLabel.isHidden = false
                } else {
                    self?.codeErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.confirmationText.map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }


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
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterPasswordViewController") as? EnterPasswordViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterEmailViewController") as? EnterEmailViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
