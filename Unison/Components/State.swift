import Foundation

protocol State: Equatable {
    static var initial: Self { get }
}
