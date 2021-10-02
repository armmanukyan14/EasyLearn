//
//  EnterPasswordViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift
import RxCocoa

final class EnterPasswordViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = EnterPasswordViewModel()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutputs()
        bindInputs()
        setupViews()
        addEyeButton()
        bindNavigation()
        setupNextButton()
        didTapEyeButton()
        setupBackButton()
    }

    private func setupBackButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }

    private func bindInputs() {
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
    }

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

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
    }

    private func setupViews() {
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

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .subscribe(onNext: { [weak self] _ in
                let addPhotoViewController = UIStoryboard.signUp.instantiateViewController(identifier: "AddPhotoViewController")
                self?.navigationController?.pushViewController(addPhotoViewController, animated: true)
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

    func addEyeButton() {
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        eyeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
    }
}
