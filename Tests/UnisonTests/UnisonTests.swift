import XCTest
@testable import Unison

final class UnisonTests: XCTestCase {
    
    typealias Sut = Unison<TestState, TestUpdate, TestEvent, TestEffectHandler>
    
    var update: TestUpdate!
    var effectHandler: TestEffectHandler!
    var spy: ValueSpy<TestState>!
    
    func test_initialState() {
        let sut = createSut()
        
        setupSpy(fulfillmentCount: 1, sut: sut)
        
        XCTAssertEqual(spy.values, [.initial])
        XCTAssertTrue(effectHandler.receivedEffects.isEmpty)
        XCTAssertTrue(update.receivedEvents.isEmpty)
    }
    
    func test_initialEffect() {
        let sut = createSut()
        
        update.initialEffect = .asyncWork
        effectHandler.result = .success
        
        setupSpy(fulfillmentCount: 2, sut: sut)
        
        spy.wait()
        
        XCTAssertEqual(spy.values, [.initial, .initial.copy(asyncResult: .success)])
        XCTAssertEqual(effectHandler.receivedEffects, [.asyncWork])
    }
    
    func test_update() {
        let sut = createSut()
        
        let events: [TestEvent] = [
            .changeValue1(input: .input),
            .toggleValue2,
            .increaseValue3,
            .toggleValue2,
            .increaseValue3,
            .decreaseValue3
        ]
        
        setupSpy(fulfillmentCount: events.count, sut: sut)
        
        events.forEach { sut.handle($0) }
        
        let expected: [TestState] = [
            .initial,
            .initial.copy(value1: .input),
            .initial.copy(value1: .input, value2: true),
            .initial.copy(value1: .input, value2: true, value3: 1),
            .initial.copy(value1: .input, value2: false, value3: 1),
            .initial.copy(value1: .input, value2: false, value3: 2),
            .initial.copy(value1: .input, value2: false, value3: 1)
        ]
        
        XCTAssertEqual(update.receivedEvents, events)
        XCTAssertEqual(spy.values, expected)
    }
    
    func test_effectResultDispatchAnotherEffect() {
        let sut = createSut()
        
        effectHandler.shouldRetry = true
        effectHandler.error = .error
        
        XCTAssertTrue(effectHandler.shouldRetry)
        
        setupSpy(fulfillmentCount: 2, sut: sut)
        
        sut.handle(.asyncWork)
        
        spy.wait()
        
        XCTAssertEqual(spy.values, [.initial, .initial.copy(asyncError: .error)])
        XCTAssertEqual(effectHandler.receivedEffects, [.asyncWork, .asyncWork])
        XCTAssertFalse(effectHandler.shouldRetry)
    }
    
    func test_updateDuringLongRunningEffect() {
        let sut = createSut()
        
        effectHandler.asyncWorkDuration = 0.01
        effectHandler.result = .success
        
        setupSpy(fulfillmentCount: 3, sut: sut)
        
        sut.handle(.asyncWork)
        sut.handle(.increaseValue3)
        
        spy.wait()
        
        XCTAssertEqual(spy.values, [.initial, .initial.copy(value3: 1), .initial.copy(value3: 1, asyncResult: .success)])
        XCTAssertEqual(update.receivedEvents, [.asyncWork, .increaseValue3])
        XCTAssertEqual(effectHandler.receivedEffects, [.asyncWork])
    }
    
    func test_deallocation() {
        let sut = createSut()
        sut.startIfNeeded()
        
        effectHandler.asyncWorkDuration = 1 // second
        effectHandler.result = .success
        
        sut.handle(.increaseValue3)
        sut.handle(.asyncWork)

        sut.stopIfNeeded()
        
        // tasks aren't cancelled immediately
        wait(timeout: 0.05)
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }
    }
    
    func test_oneEffectMultipleResults() {
        let sut = createSut()
        let workCount = 3
        
        effectHandler.result = .success
        
        setupSpy(fulfillmentCount: workCount + 1, sut: sut)
        
        sut.handle(.multipleResults(count: workCount))
        
        spy.wait()
        
        let expected: [TestState] = [
            .initial,
            .initial.copy(asyncResult: .success + "1"),
            .initial.copy(asyncResult: .success + "2"),
            .initial.copy(asyncResult: .success + "3")
        ]
        
        XCTAssertEqual(spy.values, expected)
        XCTAssertEqual(update.receivedEvents, [.multipleResults(count: workCount)])
        XCTAssertEqual(effectHandler.receivedEffects, [.multipleResults(count: workCount)])
    }
    
    // test UI events are dispatched on UI thread
    
    // event order (define - missing clarity!)
    
    // MARK: - Helper
    
    private func createSut() -> Sut {
        update = TestUpdate()
        effectHandler = TestEffectHandler()
        
        return Unison(
            initialState: .initial,
            update: update,
            effectHandler: effectHandler
        )
    }
    
    private func setupSpy(fulfillmentCount: Int, sut: Sut) {
        spy = .init(sut.$state.eraseToAnyPublisher(), fulfillmentCount: fulfillmentCount, self)
        sut.startIfNeeded()
    }
}

extension String {
    static let input = "Input"
    static let success = "Success"
    static let error = "Error"
}
