//
//  EnterPasswordViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import Firebase
import RxCocoa
import RxSwift
import UIKit

final class EnterPasswordViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: EnterPasswordViewModel!

    // MARK: - Outlets

    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var passwordErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    private lazy var eyeButton: UIButton = {
        let eyeButton = UIButton()
        eyeButton.tintColor = UIColor.textFieldBorderColor
        let eyeImage = UIImage(systemName: "eye")
        eyeButton.setImage(eyeImage, for: .normal)
        return eyeButton
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        didTapEyeButton()
        doBindings()
    }

    // MARK: - Methods

    private func setupViews() {
        nextButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Password", textField: passwordTextField)

        addEyeButton()
    }

    func addEyeButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }

    // MARK: - Reactive

    private func doBindings() {
        bindOutputs()
        bindInputs()
        bindNavigation()
    }

    // MARK: - Inputs

    private func bindInputs() {
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }

    // MARK: - Outputs

    private func bindOutputs() {
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

    // MARK: - Navigation

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .do(onNext: { [weak self] in
                let password = self?.passwordTextField.text
                let name = self?.viewModel.dependencies.name
                let email = self?.viewModel.dependencies.email
                Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name!, "email": email!, "password": password!])
                        }
                    }
                }
            })
            .withLatestFrom(viewModel.password)
            .subscribe(onNext: { [weak self] password in
                guard let self = self else { return }
                let vc = LoginViewController.getInstance(from: .logIn)
                var dependencies = self.viewModel.dependencies
                dependencies.password = password
                vc.viewModel = .init(dependencies: dependencies)
                self.navigationController?.pushViewController(vc, animated: true)
            })
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
}
