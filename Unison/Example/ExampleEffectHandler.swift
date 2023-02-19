import Foundation

final class ExampleEffectHandler: EffectHandler {
    func handle(_ effect: ExampleEffect, with state: ExampleState) async -> EffectResult<ExampleState, ExampleEffect.Result> {
//        switch result {
//        case .noChange:
//            <#code#>
//        case .newState(let state):
//            <#code#>
//        case .dispatchEffect(let state, let effect):
//            <#code#>
//        }
        return .noChange
    }
}
