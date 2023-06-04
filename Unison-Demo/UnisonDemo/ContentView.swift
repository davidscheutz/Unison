import SwiftUI

struct ContentView: View {
    
    enum Example: String, CaseIterable, Identifiable {
        case login
        case timer
        case pagination
        
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
    @ViewBuilder
    private func view(for example: Example) -> some View {
        switch example {
        case .login:
            LoginView.create(update: LoginUpdate.self, effectHandler: LoginEffectHandler.self)
        case .timer:
            TimerView.create(update: TimerUpdate.self, effectHandler: TimerEffectHandler.self)
        case .pagination:
            ListView.create(update: ListUpdate.self, effectHandler: ListEffectHandler.self)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
