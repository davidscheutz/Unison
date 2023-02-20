import Foundation

protocol Update {
    associatedtype S
    associatedtype EV
    associatedtype EF: Effect
    
    func start(_ initialState: S) -> UpdateResult<S, EF>
    func handle(event: EV, _ currentState: S) -> UpdateResult<S, EF>
    func handle(result: EF.Result, _ currentState: S) -> UpdateResult<S, EF>
}

extension Update {
    func start(_ initialState: S) -> UpdateResult<S, EF> {
        .noChange
    }
}

enum UpdateResult<State, Effect> {
    case noChange
    case newState(state: State)
    case dispatchEffect(state: State, effect: Effect)
}