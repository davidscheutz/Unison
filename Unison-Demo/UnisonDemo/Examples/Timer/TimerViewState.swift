import Foundation
import Unison

struct TimerViewState: Equatable, InitialState, SmartCopy {
    let state: TimerState
    let duration: TimeInterval
    let elapsed: TimeInterval
    let minDuration: TimeInterval
    let maxDuration: TimeInterval
    
    static let initial = TimerViewState(state: .idle, duration: 60, elapsed: 0, minDuration: 5, maxDuration: 60 * 5)
    
    // TODO: update SmartCopy template to not include private properties in copy function
//    private let durationFormatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.second, .minute]
//        formatter.zeroFormattingBehavior = .pad
//        return formatter
//    }()
    
    var elapsedFormatted: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: elapsed)!
    }
}

enum TimerState {
    case idle
    case running
    case paused
}
