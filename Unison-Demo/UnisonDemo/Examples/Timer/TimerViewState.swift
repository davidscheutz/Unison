import Foundation
import Unison

struct TimerViewState: Equatable, SmartCopy {
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
}

enum TimerState {
    case idle
    case running
    case paused
}
