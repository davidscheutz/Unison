import Foundation

public protocol EffectHandler {
    associatedtype S
    associatedtype EF: Effect
    
    func handle(_ effect: EF, with state: S) async -> EffectResult<EF.Result>
}

public protocol Effect: Equatable {
    associatedtype Result
}

public enum EffectResult<Result> {
    case repeating(AsyncStream<Result>)
    case single(Result)
    case empty
}
