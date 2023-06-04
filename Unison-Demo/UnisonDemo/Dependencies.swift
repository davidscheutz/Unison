import Unison
import SwiftDependencyContainer

struct Dependencies {
    
    private static let demo = DependencyContainer()
    
    static func setup() {
        try! demo.add { LoginApi() }
        
        Unison.register(resolver: demo)
    }
}
