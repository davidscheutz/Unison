import Foundation

enum Loadable<Data: Equatable, Error: Equatable>: Equatable {
    case loading
    case loaded(Data)
    case failed(Error)
}
