import Foundation

public protocol Update {
    associatedtype S: Equatable
    associatedtype EV
    associatedtype EF: Effect
    
    init()

    func first(state: S) -> First<S, EF>
    func handle(event: EV, _ currentState: S) -> UpdateResult<S, EF>
    func handle(result: EF.Result, _ currentState: S) -> UpdateResult<S, EF>
}

extension Update {
    public func first(state: S) -> First<S, EF> {
        .initialState(state: state)
    }
}

public enum UpdateResult<State: Equatable, Effect: Equatable>: Equatable {
    case noChange
    case newState(state: State)
    case dispatchEffect(state: State, effect: Effect)
}

public enum First<State: Equatable, Effect: Equatable>: Equatable {
    case initialState(state: State)
    case initialEffect(state: State, effect: Effect)
}

extension UpdateResult {
    public var value: State {
        get throws {
            switch self {
            case .noChange:
                throw NSError(domain: "No value", code: 0)
            case .newState(let state):
                return state
            case .dispatchEffect(let state, _):
                return state
            }
        }
    }
}
