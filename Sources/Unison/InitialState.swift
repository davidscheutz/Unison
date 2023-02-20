import Foundation

public protocol InitialState: Equatable {
    static var initial: Self { get }
}
