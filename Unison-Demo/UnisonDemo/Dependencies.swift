import Unison
import SwiftDependencyContainer

struct Dependencies {
    
    private static let demo = DependencyContainer()
    
    static func setup() {
        try! demo.add(for: [LoginApi.self, ListApi.self]) { ApiClient() }
        
        Unison.register(resolver: demo)
    }
}
