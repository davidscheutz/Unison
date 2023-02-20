import Foundation

protocol InitialState: Equatable {
    static var initial: Self { get }
}
