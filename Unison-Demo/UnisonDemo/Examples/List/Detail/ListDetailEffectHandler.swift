import Foundation
import Unison

enum ListDetailEffect: Effect {
    case loadDetail(id: String)
    
    enum Result {
        case success(ListDetail)
        case error(String)
    }
}

final class ListDetailEffectHandler: EffectHandler {
    static func create(using resolver: Resolver) -> ListDetailEffectHandler {
        ListDetailEffectHandler()
    }
    
    func handle(_ effect: ListDetailEffect) async -> EffectResult<ListDetailEffect.Result> {
        switch effect {
        case .loadDetail(let id):
            await Task.sleep(seconds: 1)
            return .single(.success(.init(hash: String(abs(id.hash)), created: Date(), size: (1_100...10_000).randomElement()!)))
        }
    }
}
