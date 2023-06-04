import Foundation
import Unison
import SwiftDependencyContainer

enum LoginEffect: Effect {
    case login(username: String, password: String)
    
    enum Result {
        case loginFailed(String)
        case resetError
    }
}

final class LoginEffectHandler: EffectHandler {
    
    private let errorDuration: TimeInterval = 3
    private let api: LoginApi
    
    private init(api: LoginApi) {
        self.api = api
    }
    
    static func create(using resolver: Resolver) -> LoginEffectHandler {
        .init(api: resolver.inferred())
    }
    
    func handle(_ effect: LoginEffect) async -> EffectResult<LoginEffect.Result> {
        switch effect {
        case .login(let username, let password):
            do {
                try await api.login(username: username, password: password)
                // navigate to e.g. home screen
                return .empty
            } catch {
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
