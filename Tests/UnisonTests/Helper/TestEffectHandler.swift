import Unison
import Foundation

class TestEffectHandler: EffectHandler {
    
    // Test config
    var result: String?
    var error: String?
    var shouldRetry = false
    var emptyResult = false
    var asyncWorkDuration: Double? // seconds
    var receivedEffects = [TestEffect]()
    
    func handle(_ effect: TestEffect) async -> EffectResult<TestEffect.Result> {
        receivedEffects.append(effect)
        
        switch effect {
        case .asyncWork:
            if emptyResult {
                return .empty
            }
            if shouldRetry {
                shouldRetry = false
                return .single(.retry)
            }
            
            if let asyncWorkDuration = asyncWorkDuration {
                try? await Task.sleep(nanoseconds: UInt64(asyncWorkDuration * 1_000_000_000))
            }
            
            if let result = result {
                return .single(.success(result: result))
            } else if let error = error {
                return .single(.failure(error: error))
            } else {
                fatalError("Invalid config")
            }
            
        case .multipleResults(let count):
            return .repeating(.init { continuation in
                for task in 0..<count {
                    continuation.yield(.success(result: result! + "\(task + 1)"))
                }
            })
        }
    }
}
