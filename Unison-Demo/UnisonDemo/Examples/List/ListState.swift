import Foundation
import Unison
import SwiftCopy

struct ListState: Copyable, Equatable {
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
