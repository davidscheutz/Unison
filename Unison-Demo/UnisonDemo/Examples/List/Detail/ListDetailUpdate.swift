import Foundation
import Unison

enum ListDetailEvent {}

final class ListDetailUpdate: Update {
    func first(state: ListDetailState) -> First<ListDetailState, ListDetailEffect> {
        .initialEffect(state: state, effect: .loadDetail(id: state.id))
    }
    
    func handle(event: ListDetailEvent, _ currentState: ListDetailState) -> UpdateResult<ListDetailState, ListDetailEffect> {}
    
    func handle(result: ListDetailEffect.Result, _ currentState: ListDetailState) -> UpdateResult<ListDetailState, ListDetailEffect> {
        switch result {
        case .success(let detail):
            return .newState(state: currentState.copy(data: .loaded(detail)))
        case .error(let error):
            return .newState(state: currentState.copy(data: .failed(error)))
        }
    }
}
