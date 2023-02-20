import SwiftUI
import Combine
import Foundation

protocol UnisonView {
    associatedtype S: State
    associatedtype EV
    
    init(state: S, handler: @escaping (EV) -> Void)
}

extension UnisonView where Self : View {
    static func create<U: Update, H: EffectHandler>(
        initialState: S = .initial,
        update: U,
        effectHandler: H
    ) -> some View where U.S == S, H.S == U.S, U.EV == EV, U.EF == H.EF {
        UnisonContainerView(
            unison: Unison(initialState: initialState, update: update, effectHandler: effectHandler),
            Self.self
        )
    }
}

struct UnisonContainerView<U: Update, H: EffectHandler, Child: UnisonView & View>: View
    where U.S == Child.S, U.EV == Child.EV, U.EF == H.EF, U.S == H.S {
    
    typealias Parent = Unison<Child.S, U, Child.EV, H>
    
    @StateObject var unison: Parent
    
    private let viewType: Child.Type
    
    init(unison: Parent, _ viewType: Child.Type) {
        _unison = .init(wrappedValue: unison)
        self.viewType = viewType
    }
    
    var body: some View {
        viewType.init(state: unison.state, handler: unison.handle)
            .onAppear { unison.startIfNeeded() }
            .onDisappear {} // stop if needed
    }
}

final class Unison<S: State, U: Update, EV, H: EffectHandler>: ObservableObject
    where U.S == S, U.EV == EV, U.EF == H.EF, H.S == S {
    
    @Published private(set) var state: S
        
    private let update: U
    private let effectHandler: H
    private var started = false
    
    init(
        initialState: S,
        update: U,
        effectHandler: H
    ) where U.S == S, U.EV == EV, U.EF == H.EF {
        state = initialState
        self.update = update
        self.effectHandler = effectHandler
    }
    
    func startIfNeeded() {
        guard !started else { return }
        started = true
        didReceive(update.start(state))
    }
    
    func handle(_ event: EV) {
        let updateResult = update.handle(event: event, state)
        didReceive(updateResult)
    }
    
    // MARK: - Helper
    
    private func didReceive(_ result: UpdateResult<S, U.EF>) {
        switch result {
        case .noChange:
            break
        case .newState(let state):
            self.update(state)
        case .dispatchEffect(let state, let effect):
            self.update(state)
            
            // synchronise tasks?
            // keep track of tasks and cancel them on view disappear
            Task {
                let effectResult = await effectHandler.handle(effect, with: state)
                
                switch effectResult {
                case .noChange:
                    break
                case .result(let result):
                    let effectUpdate = self.update.handle(result: result, self.state)
                    self.didReceive(effectUpdate)
                }
            }
        }
    }
    
    private func update(_ state: S) {
        guard self.state != state else { return }
        
        let update = { [weak self] in
            self?.state = state
        }
        
        if Thread.isMainThread {
            update()
        } else {
            DispatchQueue.main.async { update() }
        }
    }
}
