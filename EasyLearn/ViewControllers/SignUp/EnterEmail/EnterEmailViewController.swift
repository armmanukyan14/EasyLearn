//
//  EnterEmailViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift

class EnterEmailViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = EnterEmailViewModel()

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var emailErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutputs()
        bindInputs()
        setupViews()
        bindNavigation()
        setupNextButton()
    }

    private func bindInputs() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.emailText)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.emailError.skip(2)
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.emailErrorLabel.text = error
                    self?.emailErrorLabel.isHidden = false
                } else {
                    self?.emailErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.emailText.map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
    }

    private func setupViews() {
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

    private func bindNavigation() {
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterConfirmationCodeViewController") as? EnterConfirmationCodeViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterNameViewController") as? EnterNameViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
