import Foundation
import Unison

struct ListState: SmartCopy, Equatable {
    let currentPage: Int
    let data: [DemoListItem]
    let isLoading: Bool
    let error: String?
}

extension ListState: InitialState {
    static let initial = ListState(currentPage: 1, data: [], isLoading: false, error: nil)
}

struct DemoListItem: Equatable {
    let id = UUID().uuidString
    let title: String
}
