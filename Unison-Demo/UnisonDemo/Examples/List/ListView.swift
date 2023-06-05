import SwiftUI
import Unison

struct ListView: View, UnisonView {
    let state: ListState
    let handler: (ListEvent) -> Void
    
    var body: some View {
        List {
            ForEach(state.data) { item in
                NavigationLink(destination: LazyView(detail(for: item))) {
                    view(for: item)
                }
            }
        }
        .overlay { if state.data.isEmpty { loadingErrorView() } }
        .navigationTitle("Demo Items")
    }
}

extension ListView {
    private func view(for item: DemoListItem) -> some View {
        let isLast = state.data.last == item
        
        return Text(item.title)
            .id(item.id)
            .padding()
            .apply(isLast) { view in
                VStack(alignment: .leading) {
                    view
                    loadingErrorView().padding(.leading)
                }
                .onAppear { handler(.loadNextPage) }
            }
    }
    
    @ViewBuilder
    private func loadingErrorView() -> some View {
        if state.isLoading {
            ProgressView()
        } else if let error = state.error {
            Text(error).foregroundColor(.red)
        }
    }
    
    private func detail(for item: DemoListItem) -> some View {
        ListDetailView.create(
            initialState: ListDetailState(id: item.id, title: item.title, data: .loading),
            update: ListDetailUpdate.self,
            effectHandler: ListDetailEffectHandler.self
        )
    }
}

extension DemoListItem: Identifiable {}

#if DEBUG
struct ListView_Previews: PreviewProvider {
    
    static let item1 = DemoListItem(title: "Item 1")
    static let item2 = DemoListItem(title: "Item 2")
    static let item3 = DemoListItem(title: "Item 3")
    
    static let initialLoading = ListState(currentPage: 1, data: [], isLoading: true, error: nil)
    static let initialError = ListState(currentPage: 1, data: [], isLoading: false, error: "Preview Error")
    static let loaded = ListState(currentPage: 1, data: [item1, item2, item3], isLoading: false, error: nil)
    static let loadingMore = loaded.copy(isLoading: true)
    static let pageError = loaded.copy(error: .update("Preview Error"))
    
    static var previews: some View {
        render(state: initialLoading)
        render(state: initialError)
        render(state: loaded)
        render(state: loadingMore)
        render(state: pageError)
    }
    
    static func render(state: ListState) -> some View {
        ListView(state: state, handler: { _ in })
    }
}
#endif
