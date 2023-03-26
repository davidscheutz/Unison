import SwiftUI
import Combine
import Foundation

public protocol UnisonView {
    associatedtype State: Equatable
    associatedtype Event
    
    init(state: State, handler: @escaping (Event) -> Void)
}

extension UnisonView where Self : View {
    public static func create<U: Update, H: EffectHandler>(
        update: U.Type,
        effectHandler: H
    ) -> some View where U.S == State, U.EV == Event, U.EF == H.EF {
        UnisonContainerView(
            unison: Unison(update: update.init(), effectHandler: effectHandler),
            Self.self
        )
    }
}

struct UnisonContainerView<U: Update, H: EffectHandler, Child: UnisonView & View>: View
    where U.S == Child.State, U.EV == Child.Event, U.EF == H.EF {
    
    typealias Parent = Unison<Child.State, U, Child.Event, H>
    
    @StateObject var unison: Parent
    
    private let viewType: Child.Type
    
    init(unison: Parent, _ viewType: Child.Type) {
        _unison = .init(wrappedValue: unison)
        self.viewType = viewType
    }
    
    var body: some View {
        viewType.init(state: unison.state, handler: unison.handle)
            .onAppear { unison.startIfNeeded() }
            .onDisappear { unison.stopIfNeeded() }
    }
}

final class Unison<S: Equatable, U: Update, EV, H: EffectHandler>: ObservableObject
    where U.S == S, U.EV == EV, U.EF == H.EF {
    
    @Published private(set) var state: S
        
    private let update: U
    private let effectHandler: H
    private var initialEffect: U.EF?
    private var started = false
    private var runningTasks = [Task<Void, Never>]()
    
    init(
        update: U,
        effectHandler: H
    ) where U.S == S, U.EV == EV, U.EF == H.EF {
        self.update = update
        self.effectHandler = effectHandler
        
        switch update.first() {
        case .initialState(let state):
            self.state = state
        case .initialEffect(let state, let effect):
            self.state = state
            initialEffect = effect
        }
    }
    
    func startIfNeeded() {
        guard !started else { return }
        Logger.log("Unison started")
        started = true
        
        if let initialEffect = initialEffect {
            didReceive(.dispatchEffect(state: state, effect: initialEffect))
            self.initialEffect = nil
        }
    }
    
    func stopIfNeeded() {
        Logger.log("Unison stopped")
        
        runningTasks.forEach { $0.cancel() }
        runningTasks.removeAll()
    }
    
    func handle(_ event: EV) {
        Logger.log("Event received: %@", event)
        let updateResult = update.handle(event: event, state)
        didReceive(updateResult)
    }
    
    // MARK: - Helper
    
    private func didReceive(_ result: UpdateResult<S, U.EF>) {
        switch result {
        case .noChange:
            break
        case .newState(let state):
            update(state)
        case .dispatchEffect(let state, let effect):
            update(state)
            
            Logger.log("Effect dispatched: %@", effect)
            
            let task = Task { [weak self, effectHandler] in
                guard let self = self else { return }
                
                let handle: (U.EF.Result) -> Void = { result in
                    Logger.log("Effect result received: %@", result)
                    let effectUpdate = self.update.handle(result: result, self.state)
                    self.didReceive(effectUpdate)
                }
                
                switch await effectHandler.handle(effect) {
                case .empty:
                    break
                case .single(let result):
                    handle(result)
                case .repeating(let stream):
                    for await result in stream {
                        handle(result)
                    }
                }
            }
            
            runningTasks.append(task)
        }
    }
    
    private func update(_ state: S) {
        guard self.state != state else { return }
        
        Logger.log("New state received: %@", state)
        
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
