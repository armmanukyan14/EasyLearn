//
//  LogInViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 31.08.21.
//

import Foundation
import RxCocoa
import RxSwift
import STDevRxExt

class LogInViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let email = PublishRelay<String>()
    let password = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let emailError = BehaviorRelay<String?>(value: nil)
    let passwordError = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Void>()

    // MARK: - Guts

    private let isValid = PublishRelay<Bool>()

    // MARK: - Init

    let dependencies: LoginDependencies

    init(dependencies: LoginDependencies) {
        self.dependencies = dependencies
        doBindings()
    }

    // MARK: - Reactive

    private func doBindings() {
        register.withLatestFrom(email)
            .map { Validator.validate(email: $0) }
            .bind(to: emailError)
            .disposed(by: disposeBag)

        register.withLatestFrom(password)
            .map { Validator.validate(password: $0) }
            .bind(to: passwordError)
            .disposed(by: disposeBag)

        Observable.combineLatest(emailError, passwordError) {
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
