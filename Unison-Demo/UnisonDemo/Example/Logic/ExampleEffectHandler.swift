import Foundation
import Unison

enum ExampleEffect: Effect {
    case makeAPICall
}

extension ExampleEffect {
    enum Result {
        case apiCallSucceeded(result: String)
        case apiCallFailed(error: Error?)
    }
}

final class ExampleEffectHandler: EffectHandler {
    func handle(_ effect: ExampleEffect, with state: ExampleState) async -> AsyncStream<EffectResult<ExampleState, ExampleEffect.Result>> {
        .init { continuation in
            switch effect {
            case .makeAPICall:
                break
            }
            continuation.yield(.noChange)
        }
    }
}
