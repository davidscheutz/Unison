@testable import Unison
import Foundation

class TestEffectHandler: EffectHandler {
    
    // Test config
    var result: String?
    var error: String?
    var shouldRetry = false
    var asyncWorkDuration: Double? // seconds
    var receivedEffects = [TestEffect]()
    
    func handle(_ effect: TestEffect, with state: TestState) async -> EffectResult<TestState, TestEffect.Result> {
        receivedEffects.append(effect)
        
        switch effect {
        case .asyncWork:
            if shouldRetry {
                shouldRetry = false
                return .result(result: .retry)
            }
            
            if let asyncWorkDuration = asyncWorkDuration {
                try? await Task.sleep(nanoseconds: UInt64(asyncWorkDuration * 1_000_000_000))
            }
            
            if let result = result {
                return .result(result: .success(result: result))
            } else if let error = error {
                return .result(result: .failure(error: error))
            } else {
                fatalError("Invalid config")
            }
        }
    }
}
