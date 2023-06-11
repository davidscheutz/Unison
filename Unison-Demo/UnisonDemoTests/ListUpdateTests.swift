import XCTest
@testable import UnisonDemo

class ListUpdateTests: XCTestCase {
    func test_loadPage() throws {
        let sut = ListUpdate()
        
        var result = try sut.handle(event: .loadNextPage, .initial).value
        
        XCTAssertTrue(result.isLoading)
        XCTAssertEqual(result.currentPage, 1)
        
        let items: [DemoListItem] = [.init(title: "1"), .init(title: "2"), .init(title: "3")]
        
        result = try sut.handle(result: .PageLoaded(page: result.currentPage, data: items), result).value
        
        XCTAssertFalse(result.isLoading)
        XCTAssertEqual(result.currentPage, 2)
        XCTAssertEqual(result.data, items)
    }
    
    func test_loadOnlyOnePageAtATime() {
        let sut = ListUpdate()
        
        let result = sut.handle(event: .loadNextPage, .initial.copy(isLoading: true))
        
        XCTAssertEqual(result, .noChange)
    }
}
