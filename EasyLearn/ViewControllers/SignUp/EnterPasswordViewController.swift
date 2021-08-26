//
//  EnterPasswordViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift
import RxCocoa

class EnterPasswordViewController: UIViewController {

    private let disposeBag = DisposeBag()

    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
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
        setupViews()
        addEyeButton()
        bindNavigation()
        setupNextButton()
    }

    private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
        if nextButton.isEnabled {
            nextButton.backgroundColor = .easyPurple
        } else {
            nextButton.backgroundColor = .nextButtonColor
        }
    }

    private func setupViews() {
        nextButton.layer.cornerRadius = 10.0
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

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterConfirmationCodeViewController") as? EnterConfirmationCodeViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
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
