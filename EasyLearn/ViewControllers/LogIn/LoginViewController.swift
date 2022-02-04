//
//  LoginViewController.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import Firebase
import RxSwift
import UIKit

final class LoginViewController: UIViewController {
    private let userDefaultsHelper = UserDefaultsHelper.shared
    private let disposeBag = DisposeBag()
    var viewModel = LogInViewModel(dependencies: LoginDependencies())

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    @IBOutlet private var forgotPasswordButton: UIButton!
    @IBOutlet private var emailErrorLabel: UILabel!
    @IBOutlet private var passwordErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var loginErrorLabel: UILabel!

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
            .do(onNext: { [weak self] in
                self?.userDefaultsHelper.set(isLoggedIn: true)
            })
            .subscribe(onNext: { [weak self] in
                guard let email = self?.emailTextField.text,
                      let password = self?.passwordTextField.text
                else { fatalError() }
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
                    if error == nil {
                        guard let self = self else { return }
                        let vc = BaseViewController.getInstance(from: .base)
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self?.showLoginErrorAlert()
                    }
                }
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

        forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc = UIStoryboard.logIn.instantiateViewController(withIdentifier: "ForgotPasswordViewController")
                self?.navigationController?.pushViewController(vc, animated: true)
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

    private func showLoginErrorAlert() {
        let alert = UIAlertController(title: "Login Error", message: "There are no users with this email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    private func setupViews() {
        loginButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Email", textField: emailTextField)
        UITextField.setupTextField(placeholder: "Password", textField: passwordTextField)
    }

    func addEyeButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
}
