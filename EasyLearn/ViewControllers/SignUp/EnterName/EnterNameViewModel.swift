import Foundation
import RxSwift
import RxRelay
import RxCocoa

class EnterNameViewModel {
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let name = PublishRelay<String>()
    let register = PublishRelay<Void>()

    // MARK: - Outputs

    let nameError = BehaviorRelay<String?>(value: nil)
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
            .map { Validator.validate(username: $0) }
            .bind(to: nameError)
            .disposed(by: disposeBag)

        nameError.map { $0 == nil }
        .bind(to: isValid)
        .disposed(by: disposeBag)

        register
            .withLatestFrom(isValid).allowTrue()
            .map(to: ())
            .bind(to: success)
            .disposed(by: disposeBag)
}
}
