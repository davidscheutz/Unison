import SwiftUI

struct ContentView: View {
    
    enum Example: String, CaseIterable, Identifiable {
        case timer
        
        var id: String { rawValue }
        var title: String { rawValue.uppercased() }
    }
        
    var body: some View {
        NavigationView {
            List(Example.allCases) { example in
                NavigationLink(destination: LazyView(view(for: example))) {
                    Text(example.title)
                }
            }
            .navigationTitle("Examples")
        }
    }
}

extension ContentView {
    private func view(for example: Example) -> some View {
        Group {
            switch example {
            case .timer:
                TimerView.create(
                    update: TimerUpdate(),
                    effectHandler: TimerEffectHandler()
                )
            }
        }
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
