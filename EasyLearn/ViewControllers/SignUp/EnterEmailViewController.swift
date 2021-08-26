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

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
