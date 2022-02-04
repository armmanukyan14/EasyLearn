//
//  EnterConfirmationCodeViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import RxSwift
import UIKit

class EnterConfirmationCodeViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: EnterConfirmationCodeViewModel!

    // MARK: - Outlets

    @IBOutlet private var confirmationCodeTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var codeErrorLabel: UILabel!
    @IBOutlet private var backButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        doBindings()
    }

    // MARK: - Methods

    private func setupViews() {
        nextButton.layer.cornerRadius = 10
        UITextField.setupTextField(placeholder: "Confirmation code", textField: confirmationCodeTextField)
    }

    // MARK: - Reactive

    private func doBindings() {
        bindOutputs()
        bindInputs()
        bindNavigation()
    }

    // MARK: - Inputs

    private func bindInputs() {
        confirmationCodeTextField.rx.text.orEmpty
            .bind(to: viewModel.code)
            .disposed(by: disposeBag)
    }

    // MARK: - Outputs

    private func bindOutputs() {
        viewModel.confirmationError
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.codeErrorLabel.textColor = .easyPurple
                    self?.codeErrorLabel.text = error
                    self?.codeErrorLabel.isHidden = false
                } else {
                    self?.codeErrorLabel.isHidden = true
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
            .withLatestFrom(viewModel.code)
            .subscribe(onNext: { [weak self] code in
                guard let self = self else { return }
                let vc = EnterPasswordViewController.getInstance(from: .signUp)
                var dependencies = self.viewModel.dependencies
                dependencies.confirmationCode = code
                vc.viewModel = .init(dependencies: dependencies)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        confirmationCodeTextField.rx.text.orEmpty
            .bind(to: viewModel.code)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
