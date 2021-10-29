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

        Observable.combineLatest(nameError, passwordError) {
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
