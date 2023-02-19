import Foundation

protocol EffectHandler {
    associatedtype S
    associatedtype EF: Effect
    
    func handle(_ effect: EF, with state: S) async -> EffectResult<S, EF.Result>
}

protocol Effect {
    associatedtype Result
}

enum EffectResult<State, Result> {
    case noChange
    case result(result: Result)
}
