//
//  EnterNameViewController.swift
//  EasyLearn
//
//  Created by MacBook on 20.08.21.
//

import Firebase
import FirebaseDatabase
import RxCocoa
import RxSwift
import UIKit

final class EnterNameViewController: UIViewController {
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel = EnterNameViewModel()

    // MARK: - Outlets

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var nextButton: UIButton!
    @IBOutlet private var errorLabel: UILabel!
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
        UITextField.setupTextField(placeholder: "Username", textField: nameTextField)
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
    }

    // MARK: - Navigation

    private func bindNavigation() {
        nextButton.rx.tap
            .bind(to: viewModel.register)
            .disposed(by: disposeBag)

        viewModel.success
            .withLatestFrom(viewModel.name)
            .subscribe(onNext: { [weak self] name in

                let vc = EnterEmailViewController.getInstance(from: .signUp)
                vc.viewModel = .init(dependencies: .init(name: name))
                self?.navigationController?.pushViewController(vc, animated: true)

//                let editVC = EditViewController.getInstance(from: .base)
//                editVC.viewModel = .init(dependencies: .init(name: name))
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
