import Foundation
import Unison

struct LoginViewState: SmartCopy, InitialState, Equatable {
    
    struct Input: Equatable {
        static let empty = Input(value: "", error: nil)
        
        let value: String
        let error: String?
    }

    let username: Input
    let password: Input
    let isLoading: Bool
    let error: String?
    
    static let initial = LoginViewState(username: .empty, password: .empty, isLoading: false, error: nil)
}
