import Foundation

public protocol Update {
    associatedtype S: Equatable
    associatedtype EV
    associatedtype EF: Effect
    
    func start(_ initialState: S) -> UpdateResult<S, EF>
    func handle(event: EV, _ currentState: S) -> UpdateResult<S, EF>
    func handle(result: EF.Result, _ currentState: S) -> UpdateResult<S, EF>
}

extension Update {
    public func start(_ initialState: S) -> UpdateResult<S, EF> {
        .noChange
    }
}

public enum UpdateResult<State: Equatable, Effect: Equatable>: Equatable {
    case noChange
    case newState(state: State)
    case dispatchEffect(state: State, effect: Effect)
}
