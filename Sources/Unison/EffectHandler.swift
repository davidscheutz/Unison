import Foundation

public protocol EffectHandler {
    associatedtype EF: Effect
    
    static func create(using resolver: Resolver) -> Self
    
    func handle(_ effect: EF) async -> EffectResult<EF.Result>
}

public protocol Effect: Equatable {
    associatedtype Result
}

public enum EffectResult<Result> {
    case repeating(AsyncStream<Result>) // TODO: rename to 'continuation'
    case single(Result) // TODO: rename to 'completed'
    case empty
}
