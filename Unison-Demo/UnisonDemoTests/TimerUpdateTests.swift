import XCTest
@testable import UnisonDemo

final class TimerUpdateTests: XCTestCase {

    let state = TimerViewState(state: .idle, duration: 60, elapsed: 0, minDuration: 0, maxDuration: 120)

    func test_timerResetsOnFinished() {
        let sut = TimerUpdate()
        
        let runningState = state.copy(state: .running, elapsed: 10)
        
        let result = sut.handle(result: .timerFinished, runningState)
        
        XCTAssertEqual(result, .dispatchEffect(state: state, effect: .resetTimer))
    }
    
    func test_ignoreDurationChangedWhileTimerIsRunning() {
        let sut = TimerUpdate()
        
        let runningState = state.copy(state: .running, elapsed: 10)
        
        let result = sut.handle(event: .durationChanged(duration: 10), runningState)
        
        XCTAssertEqual(result, .noChange)
    }
}
