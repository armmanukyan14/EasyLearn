//
//  EnterConfirmationCodeViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 27.08.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class EnterConfirmationCodeViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let code = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let confirmationError = BehaviorRelay<String?>(value: nil)
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
        register.withLatestFrom(code)
            .map { Validator.validate(field: $0) }
            .bind(to: confirmationError)
            .disposed(by: disposeBag)

        Observable.combineLatest(confirmationError, passwordError) {
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
