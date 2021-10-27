//
//  EnterNameViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseDatabase

final class EnterNameViewController: UIViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = EnterNameViewModel()

    // MARK: - Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        didTapEyeButton()
        setupViews()
        doBindings()
    }

    // MARK: - Methods

    private func setupViews() {
        addEyeButton()
        setupEmailTextField()
        setupPasswordTextField()
        setupTextFields()
        setupNextButton()
    }

    private lazy var eyeButton: UIButton = {
        let eyeButton = UIButton()
        eyeButton.tintColor = UIColor.textFieldBorderColor
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        return eyeButton
    }()

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

    func addEyeButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }

    private func setupTitleLabel() {
        titleLabel.text = "Please enter your name."
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

    private func setupPasswordTextField() {
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.cornerRadius = 10.0
        passwordTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: passwordTextField.frame.height))
        passwordTextField.leftView = textFieldPadding
        passwordTextField.leftViewMode = .always
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
    }

    private func setupTextFields() {
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 10.0
        nameTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftView = textFieldPadding
        nameTextField.leftViewMode = .always
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.textFieldPlaceholderColor])
    }

    // MARK: - Reactive

    private func doBindings() {
        bindOutputs()
        bindInputs()
        bindNavigation()
    }

    // MARK: - Inputs
    
    private func bindInputs() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }

    // MARK: - Outputs

    private func bindOutputs() {
        viewModel.nameError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.errorLabel.textColor = .easyPurple
                    self?.errorLabel.text = error
                    self?.errorLabel.isHidden = false
                } else {
                    self?.errorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.emailError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.errorLabel.textColor = .easyPurple
                    self?.errorLabel.text = error
                    self?.errorLabel.isHidden = false
                } else {
                    self?.errorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.passwordError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.errorLabel.textColor = .easyPurple
                    self?.errorLabel.text = error
                    self?.errorLabel.isHidden = false
                } else {
                    self?.errorLabel.isHidden = true
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
            .subscribe(onNext: { [weak self] in
                if self?.titleLabel.text == "Please enter your name." {
                    self?.titleLabel.text = "Please enter your email address."
                    self?.nameTextField.isHidden = true
                    self?.passwordTextField.isHidden = true
                    self?.emailTextField.isHidden = false
                } else if self?.titleLabel.text == "Please enter your email address." {
                    self?.titleLabel.text = "Please create password."
                    self?.nameTextField.isHidden = true
                    self?.passwordTextField.isHidden = false
                    self?.emailTextField.isHidden = true
                } else if self?.titleLabel.text == "Please create password." {
                    let name = self?.nameTextField.text
                    let email = self?.emailTextField.text
                    let password = self?.passwordTextField.text
                    Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
                        if error == nil {
                            if let result = result {
                                print(result.user.uid)
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name" : name!, "email" : email!])
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

