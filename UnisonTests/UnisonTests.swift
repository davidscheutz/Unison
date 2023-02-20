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
    }
    
    func test_initialEffect() {
        let sut = createSut()
        
        update.initialEffect = .asyncWork
        effectHandler.result = .success
        
        setupSpy(fulfillmentCount: 2, sut: sut)
        
        spy.wait()
        
        XCTAssertEqual(spy.values, [.initial, .initial.copy(asyncResult: .success)])
    }
    
    func test_update() {
        let sut = createSut()
        
        let expected: [TestState] = [
            .initial,
            .initial.copy(value1: .input),
            .initial.copy(value1: .input, value2: true),
            .initial.copy(value1: .input, value2: true, value3: 1),
            .initial.copy(value1: .input, value2: false, value3: 1),
            .initial.copy(value1: .input, value2: false, value3: 2),
            .initial.copy(value1: .input, value2: false, value3: 1)
        ]
        
        setupSpy(fulfillmentCount: expected.count, sut: sut)
        
        sut.handle(.changeValue1(input: .input))
        sut.handle(.toggleValue2)
        sut.handle(.increaseValue3)
        sut.handle(.toggleValue2)
        sut.handle(.increaseValue3)
        sut.handle(.decreaseValue3)
        
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
        XCTAssertFalse(effectHandler.shouldRetry)
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
