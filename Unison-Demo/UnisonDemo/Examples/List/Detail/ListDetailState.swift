import Foundation
import Unison

struct ListDetailState: SmartCopy, Equatable {
    let id: String
    let title: String
    let data: Loadable<ListDetail, String>
}

struct ListDetail: Equatable {
    let hash: String
    let created: Date
    let size: Int
}
