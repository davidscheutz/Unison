import Foundation
import Unison

struct TimerViewState: Equatable, SmartCopy, InitialState {
    let state: TimerState
    let duration: TimeInterval
    let elapsed: TimeInterval
    let minDuration: TimeInterval
    let maxDuration: TimeInterval
        
    private static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var elapsedFormatted: String {
        Self.formatter.string(from: elapsed)!
    }
    
    static let initial = TimerViewState(state: .idle, duration: 60, elapsed: 0, minDuration: 5, maxDuration: 60 * 5)
}

enum TimerState {
    case idle
    case running
    case paused
}
