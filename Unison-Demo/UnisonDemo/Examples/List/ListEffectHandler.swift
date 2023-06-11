import Foundation
import Unison

enum ListEffect: Effect {
    case LoadPage(Int, size: Int)
    
    enum Result {
        case PageLoaded(page: Int, data: [DemoListItem])
        case ApiError
    }
}

protocol ListApi {
    func load(page: Int, size: Int) async throws -> [DemoListItem]
}

final class ListEffectHandler: EffectHandler {
    
    private let api: ListApi
    
    private init(api: ListApi) {
        self.api = api
    }
    
    static func create(using resolver: Resolver) -> ListEffectHandler {
        ListEffectHandler(api: resolver.inferred())
    }
    
    func handle(_ effect: ListEffect) async -> EffectResult<ListEffect.Result> {
        switch effect {
        case .LoadPage(let page, let size):
            do {
                let newData = try await api.load(page: page, size: size)
                return .single(.PageLoaded(page: page, data: newData))
            } catch {
                return .single(.ApiError)
            }
        }
    }
}
