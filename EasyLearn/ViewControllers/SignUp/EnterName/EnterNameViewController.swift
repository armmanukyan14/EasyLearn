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
        setupNameTextField()
        setupNextButton()
    }

     private func setupNextButton() {
        nextButton.layer.cornerRadius = 10.0
    }

    private func setupNameTextField() {
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
            .subscribe(onNext: { [weak self] _ in
                let vc = UIStoryboard.signUp.instantiateViewController(identifier: "EnterEmailViewController")
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        nameTextField.rx.text.orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)

//        viewModel.success
//            .subscribe(onNext: { [weak self] in
//                    Auth.auth().createUser(withEmail: email!, password: password!) { result, error in
//                        if error == nil {
//                            if let result = result {
//                                print(result.user.uid)
//                                let ref = Database.database().reference().child("users")
//                                ref.child(result.user.uid).updateChildValues(["name" : name!, "email" : email!])
//                            }
//                        }
//                    }
//            })
//            .disposed(by: disposeBag)

        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

