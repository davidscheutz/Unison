import Foundation
import Combine

final class StatePublisher<State>: Publisher {
    typealias Output = State
    typealias Failure = Never
    
    private let source: CurrentValueSubject<State, Never>
    
    init(source: CurrentValueSubject<State, Never>) {
        self.source = source
    }
    
    var value: State { source.value }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, State == S.Input {
        source
            .receiveOnMain()
            .receive(subscriber: subscriber)
    }
}
