import Unison
import Foundation

class TestUpdate: Update {
    
    // Test config
    var initialEffect: TestEffect?
    var receivedEvents = [TestEvent]()
    
    required init() {}
    
    func first(state: TestState) -> First<TestState, TestEffect> {
        if let initialEffect = initialEffect {
            return .initialEffect(state: state, effect: initialEffect)
        } else {
            return .initialState(state: state)
        }
    }
    
    func handle(event: TestEvent, _ currentState: TestState) -> UpdateResult<TestState, TestEffect> {
        receivedEvents.append(event)
        
        switch event {
        case .changeValue1(let input):
            return .newState(state: currentState.copy(value1: input))
        case .toggleValue2:
            var value2 = currentState.value2
            value2.toggle()
            return .newState(state: currentState.copy(value2: value2))
        case .increaseValue3:
            return .newState(state: currentState.copy(value3: currentState.value3 + 1))
        case .decreaseValue3:
            return .newState(state: currentState.copy(value3: currentState.value3 - 1))
        case .asyncWork:
            return .dispatchEffect(state: currentState, effect: .asyncWork)
        case .multipleResults(let count):
            return .dispatchEffect(state: currentState, effect: .multipleResults(count: count))
        }
    }
    
    func handle(result: TestEffect.Result, _ currentState: TestState) -> UpdateResult<TestState, TestEffect> {
        switch result {
        case .success(let result):
            return .newState(state: currentState.copy(asyncResult: result))
        case .failure(let error):
            return .newState(state: currentState.copy(asyncError: error))
        case .retry:
            return .dispatchEffect(state: currentState, effect: .asyncWork)
        }
    }
}
