import Unison
import SwiftDependencyContainer

struct Dependencies {
    static func setup() {
        try! DependencyContainer.default.add { LoginApi() }
        
        registeredResolver = DependencyContainer.default
    }
}
