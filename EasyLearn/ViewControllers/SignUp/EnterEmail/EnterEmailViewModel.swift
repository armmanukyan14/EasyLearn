//
//  EnterEmailViewModel.swift
//  EasyLearn
//
//  Created by MacBook on 27.08.21.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class EnterEmailViewModel {

    private let disposeBag = DisposeBag()

    let emailText = PublishRelay<String>()

    let emailError = BehaviorRelay<String?>(value: nil)
    let isEmailEnabled = BehaviorRelay(value: false)

    init() {
        doBindings()
    }

    private func doBindings() {
        emailText
            .map { [weak self] in self?.validate(email: $0) }
            .bind(to: emailError)
            .disposed(by: disposeBag)

    }

    private func validate(email: String) -> String? {
        let isValid = !email.isEmpty
        return isValid ? nil : "This field is required!"
    }
}
