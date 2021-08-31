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
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var nameErrorLabel: UILabel!

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
            .bind(to: viewModel.nameText)
            .disposed(by: disposeBag)
    }

    private func bindOutputs() {
        viewModel.nameError.skip(2)
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.nameErrorLabel.text = error
                    self?.nameErrorLabel.isHidden = false
                } else {
                    self?.nameErrorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)

        viewModel.nameText.map { !$0.isEmpty }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)

//        viewModel.isNameEnabled.map { $0 != true }
//            .subscribe(onNext: { [weak self] _ in
//                    self?.nextButton.backgroundColor = .easyPurple
//            })
//            .disposed(by: disposeBag)
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
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "WelcomeViewController") as? WelcomeViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)

        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if let vc = self?.storyboard?.instantiateViewController(identifier: "EnterEmailViewController") as? EnterEmailViewController {
                    self?.navigationController?.setViewControllers([vc], animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

