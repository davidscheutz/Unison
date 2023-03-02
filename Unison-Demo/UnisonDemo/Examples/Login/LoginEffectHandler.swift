import Foundation
import Unison

enum LoginEffect: Effect {
    case login(username: String, password: String)
    
    enum Result {
        case loginFailed(String)
        case resetError
    }
}

final class LoginEffectHandler: EffectHandler {
    
    private let errorDuration: TimeInterval = 3
    
    func handle(_ effect: LoginEffect, with state: LoginViewState) async -> EffectResult<LoginEffect.Result> {
        switch effect {
        case .login(let username, let password):
            // simulate API call
            try? await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000)) // 2 sec
            
            // test code
            if username == "unison" && password == "pass" {
                // navigate to e.g. home screen
                return .empty
            } else {
                return .repeating(.init { continuation in
                    continuation.yield(.loginFailed("Wrong credentials"))
                    DispatchQueue.global().asyncAfter(deadline: .now() + errorDuration) {
                        continuation.yield(.resetError)
                    }
                })
            }
        }
    }
}
