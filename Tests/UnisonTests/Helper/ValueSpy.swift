import Foundation
import XCTest
import Combine

class ValueSpy<T> {
    private(set) var values = [T]()
    private var cancellable: AnyCancellable?
    private let test: XCTestCase
    private let expectation: XCTestExpectation
    
    convenience init(subject: CurrentValueSubject<T, Never>, fulfillmentCount: Int = 1, _ test: XCTestCase) {
        self.init(subject.eraseToAnyPublisher(), fulfillmentCount: fulfillmentCount, test)
    }
    
    init(_ publisher: AnyPublisher<T, Never>, fulfillmentCount: Int = 1, _ test: XCTestCase) {
        self.test = test
        expectation = XCTestExpectation(description: "Waiting for values...")
        expectation.expectedFulfillmentCount = fulfillmentCount
        
        cancellable = publisher.sink { [weak self] in
            self?.values.append($0)
            self?.expectation.fulfill()
        }
    }
    
    func wait(timeout: Double = 0.05) {
        test.wait(for: [expectation], timeout: timeout)
    }
}

