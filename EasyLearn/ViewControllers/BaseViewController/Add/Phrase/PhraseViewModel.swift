//
//  PhraseViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 26.03.22.
//

import Foundation
import RxSwift
import RxRelay

final class PhraseViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let phrase = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let phraseError = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Void>()

    // MARK: - Guts

    private let isValid = PublishRelay<Bool>()

    // MARK: - Init

    init() {
        doBindings()
    }

    // MARK: - Reactive

    private func doBindings() {
        register.withLatestFrom(phrase)
            .map { Validator.validate(phrase: $0)}
            .bind(to: phraseError)
            .disposed(by: disposeBag)

        phraseError.map { $0 == nil }
        .bind(to: isValid)
        .disposed(by: disposeBag)

        register
            .withLatestFrom(isValid).allowTrue()
            .map(to: ())
            .bind(to: success)
            .disposed(by: disposeBag)
    }
}
