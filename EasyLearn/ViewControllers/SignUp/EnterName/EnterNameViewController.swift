//
//  EnterNameViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import UIKit
import RxSwift
import RxCocoa

final class EnterNameViewController: UIViewController {

    private let disposeBag = DisposeBag()
     private let viewModel = EnterNameViewModel()

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var nameErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        bindOutputs()
        bindInputs()
        setupTextFields()
        bindNavigation()
        setupNextButton()
    }

    private func bindInputs() {
        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.nameError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.nameErrorLabel.textColor = .easyPurple
                    self?.nameErrorLabel.text = error
                    self?.nameErrorLabel.isHidden = false
                } else {
                    self?.nameErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
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

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .subscribe(onNext: { [weak self] _ in
                let enterEmailViewController = UIStoryboard.signUp.instantiateViewController(identifier: "EnterEmailViewController")
                self?.navigationController?.pushViewController(enterEmailViewController, animated: true)
            })
            .disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

