import SwiftUI
import Unison

struct ListView: View, UnisonView {
    let state: ListState
    let handler: (ListEvent) -> Void
    
    var body: some View {
        List {
            ForEach(state.data) { item in
                let isLast = state.data.last == item
                
                Text(item.title)
                    .id(item.id)
                    .padding()
                    .onTapGesture { handler(.didSelectItem(id: item.id)) }
                    .apply(isLast) { view in
                        VStack(alignment: .leading) {
                            view
                            ProgressView().padding(.leading)
                        }
                        .onAppear { handler(.loadNextPage) }
                    }
            }
        }
        .overlay {
            if state.data.isEmpty && state.isLoading {
                ProgressView()
            }
        }
        .navigationTitle("Demo Items")
    }
}

extension DemoListItem: Identifiable {}

#if DEBUG
struct ListView_Previews: PreviewProvider {
    
    static let loaded = ListState(currentPage: 1, data: [.init(title: "Item 1"), .init(title: "Item 2")], isLoading: false, error: nil)
//    static let loadingMore = ListState(currentPage: 1, data: [.init(title: <#T##String#>), .init(title: <#T##String#>)], isLoading: false, error: nil)
//    static let pageError = ListState(currentPage: 1, data: [.init(title: <#T##String#>), .init(title: <#T##String#>)], isLoading: false, error: nil)
    
    static var previews: some View {
        ListView(state: loaded, handler: { _ in })
    }
}
#endif
