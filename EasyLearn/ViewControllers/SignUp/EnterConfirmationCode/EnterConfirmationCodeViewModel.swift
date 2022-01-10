//
//  EnterConfirmationCodeViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 27.08.21.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

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

    let dependencies: LoginDependencies

    init(dependencies: LoginDependencies) {
        self.dependencies = dependencies
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
