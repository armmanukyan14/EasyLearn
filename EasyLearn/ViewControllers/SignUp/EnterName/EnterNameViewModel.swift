//
//  EnterNameViewController.swift
//  EasyLearn
//
//  Created by MacBook on 21.08.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import STDevRxExt

class EnterNameViewModel {

    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let name = PublishRelay<String>()
    let email = PublishRelay<String>()
    let password = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let nameError = BehaviorRelay<String?>(value: nil)
    let emailError = BehaviorRelay<String?>(value: nil)
    let passwordError = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Void>()

    // MARK: - Guts

    private let isValid = PublishRelay<Bool>()

    // MARK: - Init

    init() {
        doBindings()
    }

    // MARK: - Reactive

    private func doBindings() {
        register.withLatestFrom(name)
            .map { Validator.validate(field: $0) }
            .bind(to: nameError)
            .disposed(by: disposeBag)

        register.withLatestFrom(email)
            .map { Validator.validate(email: $0) }
            .bind(to: emailError)
            .disposed(by: disposeBag)

        register.withLatestFrom(password)
            .map { Validator.validate(password: $0) }
            .bind(to: passwordError)
            .disposed(by: disposeBag)

//        Observable.combineLatest(nameError, emailError, passwordError) {
//            $0 == nil && $1 == nil && $2 == nil
//        }
//        .bind(to: isValid)
//        .disposed(by: disposeBag)

        register
            .withLatestFrom(isValid).allowTrue()
            .map(to: ())
            .bind(to: success)
            .disposed(by: disposeBag)
    }
}
