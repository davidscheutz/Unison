import SwiftUI
import Unison

struct ExampleView: View, UnisonView {
    
    let state: ExampleState
    let handler: (ExampleEvent) -> Void
    
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
