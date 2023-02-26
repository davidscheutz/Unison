import XCTest
@testable import UnisonDemo

final class TimerUpdateTests: XCTestCase {
    
    func test_timerResetsOnFinished() {
        let sut = TimerUpdate()
        
        let runningState = TimerViewState.initial.copy(state: .running, elapsed: 10)
        
        let result = sut.handle(result: .timerFinished, runningState)
        
        XCTAssertEqual(result, .dispatchEffect(state: .initial, effect: .resetTimer))
    }
    
    func test_ignoreDurationChangedWhileTimerIsRunning() {
        let sut = TimerUpdate()
        
        let runningState = TimerViewState.initial.copy(state: .running, elapsed: 10)
        
        let result = sut.handle(event: .durationChanged(duration: 10), runningState)
        
        XCTAssertEqual(result, .noChange)
    }
}
