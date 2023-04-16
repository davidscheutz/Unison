import Foundation
import Unison

enum TimerEvent {
    case start
    case pause
    case reset
    case durationChanged(duration: TimeInterval)
}

final class TimerUpdate: Update, InitialUpdate {
    
    func first() -> First<TimerViewState, TimerEffect> {
        let initial = TimerViewState(state: .idle, duration: 60, elapsed: 0, minDuration: 5, maxDuration: 60 * 5)
        return .initialState(state: initial)
    }
    
    func handle(event: TimerEvent, _ currentState: TimerViewState) -> UpdateResult<TimerViewState, TimerEffect> {
        switch event {
        case .start:
            guard currentState.state != .running else {
                return .noChange
            }
            return .dispatchEffect(
                state: currentState.copy(state: .running),
                effect: .startTimer(elapsed: currentState.elapsed, duration: currentState.duration)
            )
        case .pause:
            guard currentState.state != .paused else {
                return .noChange
            }
            return .dispatchEffect(state: currentState.copy(state: .paused), effect: .resetTimer)
        case .reset:
            guard currentState.state != .idle else {
                return .noChange
            }
            return .dispatchEffect(state: currentState.copy(state: .idle, elapsed: 0), effect: .resetTimer)
        case .durationChanged(let duration):
            guard currentState.state != .running else {
                return .noChange
            }
            return .newState(state: currentState.copy(duration: duration))
        }
    }
    
    func handle(result: TimerEffect.Result, _ currentState: TimerViewState) -> UpdateResult<TimerViewState, TimerEffect> {
        switch result {
        case .timeEllapsed(let elapsed):
            guard currentState.state == .running else {
                return .noChange
            }
            return .newState(state: currentState.copy(elapsed: elapsed))
        case .timerFinished:
            return .dispatchEffect(
                state: currentState.copy(state: .idle, elapsed: 0),
                effect: .resetTimer
            )
        }
    }
}
