import Unison

enum ListEvent {
    case loadNextPage
    case didSelectItem(id: String)
}

final class ListUpdate: Update {
    
    func first(state: ListState) -> First<ListState, ListEffect> {
        .initialEffect(state: state.copy(isLoading: true), effect: .LoadPage(state.currentPage))
    }
    
    func handle(event: ListEvent, _ currentState: ListState) -> UpdateResult<ListState, ListEffect> {
        switch event {
        case .loadNextPage:
            guard !currentState.isLoading else {
                return .noChange
            }
            return .dispatchEffect(state: currentState.copy(isLoading: true), effect: .LoadPage(currentState.currentPage))
        case .didSelectItem(let id):
            // TODO
            return .noChange
        }
    }
    
    func handle(result: ListEffect.Result, _ currentState: ListState) -> UpdateResult<ListState, ListEffect> {
        switch result {
        case .PageLoaded(let page, let data):
            return .newState(state: currentState.copy(currentPage: page + 1, data: currentState.data + data, isLoading: false, error: .reset))
        case .ApiError:
            return .newState(state: currentState.copy(isLoading: false, error: .update("Can't load next page.")))
        }
    }
}
