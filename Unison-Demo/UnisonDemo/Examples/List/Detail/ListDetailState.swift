import Foundation
import Unison

struct ListDetailState: SmartCopy, Equatable {
    let id: String
    let title: String
    let data: LoadableData<ListDetail, String>
}

struct ListDetail: Equatable {
    let hash: String
    let created: Date
    let size: Int
}

// TODO: should this come with Mobius?
enum LoadableData<T: Equatable, E: Equatable>: Equatable {
    case loading
    case loaded(T)
    case failed(E)
}
