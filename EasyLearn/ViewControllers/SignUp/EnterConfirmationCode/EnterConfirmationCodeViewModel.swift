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

    let confirmationText = PublishRelay<String>()

    let confirmationError = BehaviorRelay<String?>(value: nil)
    let isConfirmationEnabled = BehaviorRelay(value: false)

    init() {
        doBindings()
    }

    private func doBindings() {
        confirmationText
            .map { [weak self] in self?.validate(confirm: $0) }
            .bind(to: confirmationError)
            .disposed(by: disposeBag)

    }

    private func validate(confirm: String) -> String? {
        let isValid = !confirm.isEmpty
        return isValid ? nil : "This field is required!"
    }
}
