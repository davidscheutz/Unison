import Foundation
import SwiftDependencyContainer

public protocol Resolver {
    func inferred<T>() -> T
    func named<Key, T>(_ key: Key) -> T
}

public final class Unison {
    internal static var resolver: Resolver?
    
    public static func register(resolver: Resolver) {
        self.resolver = resolver
    }
}

// MARK: - Third party integrations

extension DependencyContainer: Resolver {
    public func inferred<T>() -> T {
        try! resolve()
    }
    
    public func named<Key, T>(_ key: Key) -> T {
        if let hashableKey = key as? (any Hashable) {
            return try! resolve(hashableKey)
        } else {
            return try! resolve("\(key)")
        }
    }
}
