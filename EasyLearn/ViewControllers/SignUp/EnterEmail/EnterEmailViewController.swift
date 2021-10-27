////
////  EnterEmailViewController.swift
////  EasyLearn
////
////  Created by MacBook on 20.08.21.
////
//
//import RxSwift
//import UIKit
//
//class EnterEmailViewController: UIViewController {
//    private let disposeBag = DisposeBag()
//    private let viewModel = EnterEmailViewModel()
//
//    @IBOutlet private var nextButton: UIButton!
//    @IBOutlet private var emailErrorLabel: UILabel!
//    @IBOutlet private var backButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        bindOutputs()
//        bindInputs()
//        setupViews()
//        bindNavigation()
//        setupNextButton()
//        setupBackButton()
//    }
//
//    private func setupBackButton() {
//        navigationItem.backBarButtonItem = UIBarButtonItem(
//            title: "", style: .plain, target: nil, action: nil)
//    }
//
//    private func bindInputs() {
//        emailTextField.rx.text.orEmpty
//            .bind(to: viewModel.email)
//            .disposed(by: disposeBag)
//    }
//
//    private func bindOutputs() {
//        viewModel.emailError
//            .subscribe(onNext: { [weak self] error in
//                if let error = error {
//                    self?.emailErrorLabel.textColor = .easyPurple
//                    self?.emailErrorLabel.text = error
//                    self?.emailErrorLabel.isHidden = false
//                } else {
//                    self?.emailErrorLabel.isHidden = true
//                }
//            })
//            .disposed(by: disposeBag)
//    }
//
//    private func setupNextButton() {
//        nextButton.layer.cornerRadius = 10.0
//    }
//
//
//    private func bindNavigation() {
//        nextButton.rx.tap
//            .bind(to: viewModel.register)
//            .disposed(by: disposeBag)
//
//        viewModel.success
//            .subscribe(onNext: { [weak self] _ in
//                let enterConfirmationCodeViewController = UIStoryboard.signUp.instantiateViewController(identifier: "EnterConfirmationCodeViewController")
//                self?.navigationController?.pushViewController(enterConfirmationCodeViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
//
//        emailTextField.rx.text.orEmpty
//            .bind(to: viewModel.email)
//            .disposed(by: disposeBag)
//
//
//        
//        backButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
//    }
//}
