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
        effectHandler: H.Type
    ) -> some View where U : InitialUpdate, U.S == State, U.EV == Event, U.EF == H.EF {
        create(update: update, effectHandler: effectHandler.create(using: resolver))
    }
    
    public static func create<U: Update, H: EffectHandler>(
        update: U.Type,
        effectHandler: H.Type
    ) -> some View where State : InitialState, U.S == State, U.EV == Event, U.EF == H.EF {
        create(update: update, effectHandler: effectHandler.create(using: resolver))
    }
    
    public static func create<U: Update, H: EffectHandler>(
        update: U.Type,
        effectHandler: H
    ) -> some View where U : InitialUpdate, U.S == State, U.EV == Event, U.EF == H.EF {
        UnisonContainerView(
            unison: Unison(update: update.init(), effectHandler: effectHandler),
            Self.self
        )
    }
    
    public static func create<U: Update, H: EffectHandler>(
        update: U.Type,
        effectHandler: H
    ) -> some View where State : InitialState, U.S == State, U.EV == Event, U.EF == H.EF {
        UnisonContainerView(
            unison: Unison(update: update, effectHandler: effectHandler),
            Self.self
        )
    }
    
    public static func create<U: Update, H: EffectHandler>(
        initialState: State,
        update: U.Type,
        effectHandler: H
    ) -> some View where U.S == State, U.EV == Event, U.EF == H.EF {
        UnisonContainerView(
            unison: Unison(initialState: initialState, update: update, effectHandler: effectHandler),
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
