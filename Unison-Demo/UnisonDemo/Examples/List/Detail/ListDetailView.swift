import SwiftUI
import Unison

struct ListDetailView: View, UnisonView {
    
    let state: ListDetailState
    let handler: (ListDetailEvent) -> Void
    
    var body: some View {
        VStack {
            switch state.data {
            case .loading:
                ProgressView()
            case .loaded(let data):
                render(detail: data)
            case .failed(let error):
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(state.title)
    }
}

extension ListDetailView {
    private func render(detail: ListDetail) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hash").bold()
            Text(detail.hash)
            
            Divider()
            
            Text("Created At:").bold()
            Text("\(detail.created)")
            
            Divider()
            
            Text("Size").bold()
            Text("\(detail.size)")
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#if DEBUG
struct ListDetailView_Previews: PreviewProvider {
    static let detail = ListDetail(hash: "gdvrqbvuoevboqev", created: Date(), size: 123)
    
    static var previews: some View {
        render(detail: .loading)
        render(detail: .loaded(detail))
        render(detail: .failed("Preview Error"))
    }
    
    static func render(detail: Loadable<ListDetail, String>) -> some View {
        NavigationView {
            ListDetailView(state: .init(id: "", title: "Title", data: detail), handler: { _ in })
        }
    }
}
#endif
