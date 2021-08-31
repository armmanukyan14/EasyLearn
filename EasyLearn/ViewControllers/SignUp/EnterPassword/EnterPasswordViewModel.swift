//
//  EnterPasswordViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 27.08.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class EnterPasswordViewModel {
    private let disposeBag = DisposeBag()

    let passwordText = PublishRelay<String>()

    let passwordError = BehaviorRelay<String?>(value: nil)
    let isPasswordEnabled = BehaviorRelay(value: false)

    init() {
        doBindings()
    }

    private func doBindings() {
        passwordText
            .map { [weak self] in self?.validate(password: $0) }
            .bind(to: passwordError)
            .disposed(by: disposeBag)

    }

    private func validate(password: String) -> String? {
        let isValid = !password.isEmpty
        return isValid ? nil : "This field is required!"
    }
}

