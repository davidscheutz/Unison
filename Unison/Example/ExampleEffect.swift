import Foundation

enum ExampleEffect: Effect {
    case makeAPICall
}

extension ExampleEffect {
    enum Result {
        case apiCallSucceeded(result: String)
        case apiCallFailed(error: Error?)
    }
}
