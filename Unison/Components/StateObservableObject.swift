import SwiftUI
import Combine

final class StateObservableObject<S>: ObservableObject {
    
    @Published private(set) var state: S
    
    init(source: CurrentValueSubject<S, Never>) {
        state = source.value
        
        source
            .receiveOnMain()
            .assign(to: &$state)
    }
}
