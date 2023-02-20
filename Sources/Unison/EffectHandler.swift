import Foundation

public protocol EffectHandler {
    associatedtype S
    associatedtype EF: Effect
    
    func handle(_ effect: EF, with state: S) async -> EffectResult<S, EF.Result>
}

public protocol Effect {
    associatedtype Result
}

public enum EffectResult<State, Result> {
    case noChange
    case result(result: Result)
}
