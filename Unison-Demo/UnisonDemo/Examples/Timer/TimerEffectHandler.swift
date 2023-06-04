import Foundation
import Unison

enum TimerEffect: Effect {
    case startTimer(elapsed: TimeInterval, duration: TimeInterval)
    case pauseTimer
    case resetTimer
    
    enum Result {
        case timeEllapsed(elapsed: TimeInterval)
        case timerFinished
    }
}

final class TimerEffectHandler: EffectHandler {
    static func create(using resolver: Resolver) -> TimerEffectHandler {
        TimerEffectHandler()
    }
    
    private var timer: Timer?
    private let interval: TimeInterval = 0.5
    
    func handle(_ effect: TimerEffect) async -> EffectResult<TimerEffect.Result> {
        switch effect {
        case .startTimer(let elapsed, let duration):
            return await .repeating(startTimer(with: duration, elapsed: elapsed))
        case .pauseTimer, .resetTimer:
            invalidateTimer()
            return .empty
        }
    }
    
    // MARK: Helper
    
    @MainActor
    private func startTimer(with duration: TimeInterval, elapsed: TimeInterval) -> AsyncStream<TimerEffect.Result> {
        let startTime = Date(timeIntervalSince1970: Date().timeIntervalSince1970 - elapsed)

        return .init { continuation in
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
                guard timer.isValid else {
                    continuation.finish()
                    return
                }
                
                let elapsed = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
                if elapsed < duration {
                    continuation.yield(.timeEllapsed(elapsed: elapsed))
                } else {
                    continuation.yield(with: .success(.timerFinished))
                }
            }
            
            RunLoop.main.add(timer!, forMode: .common)
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
    }
}
