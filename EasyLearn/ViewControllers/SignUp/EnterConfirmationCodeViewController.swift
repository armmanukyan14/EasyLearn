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

    @IBOutlet private var confirmationCodeTextField: UITextField!
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
