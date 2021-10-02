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

    // MARK: - Inputs

    let password = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let passwordError = BehaviorRelay<String?>(value: nil)
    let emailError = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Void>()

    // MARK: - Guts

    private let isValid = PublishRelay<Bool>()

    // MARK: - Init

    init() {
        doBindings()
    }

    // MARK: - Reactive

    private func doBindings() {
        register.withLatestFrom(password)
            .map { Validator.validate(password: $0) }
            .bind(to: passwordError)
            .disposed(by: disposeBag)

        Observable.combineLatest(passwordError, emailError) {
            $0 == nil && $1 == nil
        }
        .bind(to: isValid)
        .disposed(by: disposeBag)

        register
            .withLatestFrom(isValid).allowTrue()
            .map(to: ())
            .bind(to: success)
            .disposed(by: disposeBag)
}
}
