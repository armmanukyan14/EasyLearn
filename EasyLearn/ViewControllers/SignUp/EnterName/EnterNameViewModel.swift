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

    let nameText = PublishRelay<String>()

    let nameError = BehaviorRelay<String?>(value: nil)
    let isNameEnabled = BehaviorRelay(value: false)

    init() {
        doBindings()
    }

    private func doBindings() {
        nameText
            .map { [weak self] in self?.validate(name: $0) }
            .bind(to: nameError)
            .disposed(by: disposeBag)

    }

    private func validate(name: String) -> String? {
        let isValid = !name.isEmpty
        return isValid ? nil : "This field is required!"
    }
}
