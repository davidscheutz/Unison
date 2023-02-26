import Unison
import Foundation

class TestEffectHandler: EffectHandler {
    
    // Test config
    var result: String?
    var error: String?
    var shouldRetry = false
    var asyncWorkDuration: Double? // seconds
    var receivedEffects = [TestEffect]()
    
    func handle(_ effect: TestEffect, with state: TestState) -> AsyncStream<EffectResult<TestState, TestEffect.Result>> {
        receivedEffects.append(effect)
        
        return .init { continuation in
            switch effect {
            case .asyncWork:
                if shouldRetry {
                    shouldRetry = false
                    continuation.yield(.result(result: .retry))
                }
                
                if let asyncWorkDuration = asyncWorkDuration {
                    Thread.sleep(forTimeInterval: asyncWorkDuration)
                }
                
                if let result = result {
                    continuation.yield(.result(result: .success(result: result)))
                } else if let error = error {
                    continuation.yield(.result(result: .failure(error: error)))
                } else {
                    fatalError("Invalid config")
                }
                
            case .multipleResults(let count):
                for task in 0..<count {
                    continuation.yield(.result(result: .success(result: result! + "\(task + 1)")))
                }
            }
        }
    }
}
