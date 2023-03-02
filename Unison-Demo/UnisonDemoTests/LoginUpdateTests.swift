import XCTest
@testable import UnisonDemo

final class LoginUpdateTests: XCTestCase {
    
    func test_inputValidationOnLogin() throws {
        let sut = LoginUpdate()
        
        let input = "invalid"
        
        var result = sut.handle(event: .usernameChanged(input), .initial)
        
        XCTAssertEqual(result, .newState(state: .initial.copy(username: .init(value: input, error: nil))))
        
        result = sut.handle(event: .login, try result.value)
        
        XCTAssertNotNil(try result.value.username.error)
        XCTAssertNotNil(try result.value.password.error)
    }
}
