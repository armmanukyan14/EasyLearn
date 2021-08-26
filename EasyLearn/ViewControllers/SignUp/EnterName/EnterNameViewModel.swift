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

class EnterNameViewModel {

    private let disposeBag = DisposeBag()

    let nameTextInput = PublishRelay<String>()

    let nameError = BehaviorRelay<String?>(value: nil)
    let emailError = BehaviorRelay<String?>(value: nil)
    let isNameEnabled = BehaviorRelay(value: false)

    init() {
        doBindings()
    }

    private func doBindings() {

        nameTextInput
            .map { [weak self] in self?.validate(name: $0) }
            .bind(to: nameError)
            .disposed(by: disposeBag)

        Observable.combineLatest(nameError, emailError) {
            $0 == nil && $1 == nil
        }

        .bind(to: isNameEnabled)
        .disposed(by: disposeBag)
    }

    private func validate(name: String) -> String? {
        let isValid = !name.isEmpty
        return isValid ? nil : "This field cannot be empty!"
    }
}
