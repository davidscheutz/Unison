//
//  ExampleView.swift
//  Unison
//
//  Created by David's MBP16 on 19.02.23.
//

import SwiftUI
import Combine

struct ExampleView: View, UnisonView {
    
    let state: ExampleState
    let handler: (ExampleEvent) -> Void
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// ------------- Alternatives ------------- //

struct ExampleView_Publisher: View {
    
    @State private var state: ExampleState
    
    private let handler: (ExampleEvent) -> Void
    private let statePublisher: AnyPublisher<ExampleState, Never>
    
    init(source: StatePublisher<ExampleState>, handler: @escaping (ExampleEvent) -> Void) {
        _state = .init(initialValue: source.value)
        statePublisher = source.eraseToAnyPublisher()
        self.handler = handler
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ExampleView_Observable: View {
    
    @StateObject private var state: StateObservableObject<ExampleState>
    
    private let handler: (ExampleEvent) -> Void
    
    init(source: StateObservableObject<ExampleState>, handler: @escaping (ExampleEvent) -> Void) {
        _state = .init(wrappedValue: source)
        self.handler = handler
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#if DEBUG
struct ExampleView_Previews: PreviewProvider {

    static let emptyState = ExampleState(input: "", isButtonActive: false, isLoading: false)
    static let loadingState = ExampleState(input: "Input", isButtonActive: false, isLoading: true)

    static var previews: some View {
        render(emptyState)
        render(loadingState)
    }

    static func render(_ state: ExampleState) -> some View {
        ExampleView(state: state, handler: { _ in })
    }
}
#endif
