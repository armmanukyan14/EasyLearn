//
//  LoginViewController.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import RxSwift
import UIKit

final class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = LogInViewModel()

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var forgotPasswordButton: UIButton!
    @IBOutlet private var emailErrorLabel: UILabel!
    @IBOutlet private var passwordErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    private lazy var eyeButton: UIButton = {
        let eyeButton = UIButton()
        eyeButton.tintColor = UIColor.textFieldBorderColor
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        return eyeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
        setupViews()
        addEyeButton()
        didTapEyeButton()
        closeKeyboardWhenTapped()
    }

    private func doBindings() {
        bindOutputs()
        bindInputs()
        bindNavigation()
    }

    private func bindNavigation() {
        loginButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .subscribe(onNext: { [weak self] _ in
                let baseViewController = UIStoryboard.base.instantiateViewController(identifier: "BaseViewController")
                self?.navigationController?.pushViewController(baseViewController, animated: true)
            })
            .disposed(by: disposeBag)

        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
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

        viewModel.passwordError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.passwordErrorLabel.textColor = .easyPurple
                    self?.passwordErrorLabel.text = error
                    self?.passwordErrorLabel.isHidden = false
                } else {
                    self?.passwordErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindInputs() {
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }

    private func didTapEyeButton() {
        eyeButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                if self?.eyeButton.currentImage == UIImage(systemName: "eye") {
                    self?.eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                    self?.passwordTextField.isSecureTextEntry = false
                } else {
                    self?.eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
                    self?.passwordTextField.isSecureTextEntry = true
                }
            })
            .disposed(by: disposeBag)
    }

    private func closeKeyboardWhenTapped() {
        let tapBackground = UITapGestureRecognizer()
        view.addGestureRecognizer(tapBackground)
        tapBackground.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        loginButton.layer.cornerRadius = 10.0

        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.cornerRadius = 10.0
        emailTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: emailTextField.frame.height))
        emailTextField.leftView = textFieldPadding
        emailTextField.leftViewMode = .always
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])

        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding1 = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = textFieldPadding1
        passwordTextField.leftViewMode = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }

    func addEyeButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
}
