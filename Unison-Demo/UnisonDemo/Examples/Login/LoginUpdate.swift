import Foundation
import Unison

enum LoginEvent  {
    case usernameChanged(String)
    case passwordChanged(String)
    case login
}

final class LoginUpdate: Update {
    
    typealias Result = UpdateResult<LoginViewState, LoginEffect>
    
    func handle(event: LoginEvent, _ currentState: LoginViewState) -> Result {
        switch event {
        case .usernameChanged(let username):
            return .newState(state: currentState.copy(username: .init(value: username, error: nil)))
        case .passwordChanged(let password):
            return .newState(state: currentState.copy(password: .init(value: password, error: nil)))
        case .login:
            return login(state: currentState)
        }
    }
    
    func handle(result: LoginEffect.Result, _ currentState: LoginViewState) -> Result {
        switch result {
        case .loginFailed(let error):
            return .newState(state: currentState.copy(isLoading: false, error: error))
        case .resetError:
            // TODO: make copy function support resetting optionals
            return .newState(state: currentState.copy(error: nil))
        }
    }
    
    // MARK: - Helper
    
    private func login(state: LoginViewState) -> Result {
        guard !state.isLoading else { return .noChange }
        
        var newState = state
        
        let username = newState.username.value
        let password = newState.password.value
        
        if !username.isValidEmail {
            newState = newState.copy(username: .init(value: username, error: "Please enter a valid email"))
        }
        
        if password.isEmpty {
            newState = newState.copy(password: .init(value: password, error: "Password can't be empty"))
        }
        
        guard newState == state else {
            return .newState(state: newState)
        }
        
        return .dispatchEffect(
            state: state.copy(isLoading: true, error: nil),
            effect: .login(username: username, password: password)
        )
    }
}
