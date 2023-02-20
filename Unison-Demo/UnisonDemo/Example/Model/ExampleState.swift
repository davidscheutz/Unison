import Foundation
import Unison

struct ExampleState: InitialState {
    let input: String
    let isButtonActive: Bool
    let isLoading: Bool
    
    static let initial = ExampleState(input: "", isButtonActive: false, isLoading: false)
}
