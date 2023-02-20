@testable import Unison

struct TestState: State {
    let value1: String
    let value2: Bool
    let value3: Int
    let asyncResult: String?
    let asyncError: String?
    
    static let initial = TestState(value1: "", value2: false, value3: 0, asyncResult: nil, asyncError: nil)
}

extension TestState {
    func copy(value1: String? = nil,  value2: Bool? = nil, value3: Int? = nil, asyncResult: String? = nil, asyncError: String? = nil) -> Self {
        .init(
            value1: value1 ?? self.value1,
            value2: value2 ?? self.value2,
            value3: value3 ?? self.value3,
            asyncResult: asyncResult ?? self.asyncResult,
            asyncError: asyncError ?? self.asyncError
        )
    }
}

enum TestEvent {
    case changeValue1(input: String)
    case toggleValue2
    case increaseValue3
    case decreaseValue3
    case asyncWork
}

enum TestEffect: Effect {
    case asyncWork
}

extension TestEffect {
    enum Result {
        case success(result: String)
        case failure(error: String)
        case retry
    }
}
