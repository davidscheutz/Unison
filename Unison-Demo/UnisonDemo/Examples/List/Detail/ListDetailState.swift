import Foundation
import Unison
import SwiftCopy

struct ListDetailState: Copyable, Equatable {
    let id: String
    let title: String
    let data: Loadable<ListDetail, String>
}

struct ListDetail: Equatable {
    let hash: String
    let created: Date
    let size: Int
}
