import Foundation
import Unison

// pure code (stateless, deterministic & no side effects) = easily testable
enum ExampleEvent {
    case buttonClicked
    case textChanged(text: String)
}

final class ExampleUpdate: Update {
    
    func start(_ initialState: ExampleState) -> UpdateResult<ExampleState, ExampleEffect> {
        .dispatchEffect(state: initialState, effect: .makeAPICall)
    }
    
    func handle(event: ExampleEvent, _ currentState: ExampleState) -> UpdateResult<ExampleState, ExampleEffect> {
        switch event {
        case .textChanged(let text): return .newState(state: currentState.copy(input: text))
        case .buttonClicked: break
        }
        return .noChange
    }
    
    func handle(result: ExampleEffect.Result, _ currentState: ExampleState) -> UpdateResult<ExampleState, ExampleEffect> {
        switch result {
        case .apiCallSucceeded(let result):
            break
        case .apiCallFailed(let error):
            break
        }
        return .noChange
    }
}
