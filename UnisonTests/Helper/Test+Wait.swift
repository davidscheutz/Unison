import XCTest

extension XCTestCase {
    func wait(timeout: TimeInterval) {
        let expectation = expectation(description: "Waiting...")
        expectation.isInverted = true
        wait(for: [expectation], timeout: timeout)
    }
}
