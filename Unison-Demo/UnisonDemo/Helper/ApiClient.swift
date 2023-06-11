import Foundation

final class ApiClient {}
    
extension ApiClient: LoginApi {
    func login(username: String, password: String) async throws {
        // simulate API call
        await sleep(2)
        
        if username == "unison" && password == "pass" {
            // success
        } else {
            throw NSError(domain: "Invalid credentials", code: 400)
        }
    }
}

extension ApiClient: ListApi {
    func load(page: Int, size: Int) async throws -> [DemoListItem] {
        // simulate API call
        await randomSleep()
        
        return (1...size).map { DemoListItem(title: "Page: \(page) - Item: \((page - 1) * size + $0)") }
    }
}

// MARK: - Helper

extension ApiClient {
    
    private func randomSleep(_ range: ClosedRange<Double> = 1.5...2.5) async {
        await sleep(Double.random(in: range))
    }
    
    private func sleep(_ seconds: Double) async {
        await Task.sleep(seconds: seconds)
    }
}
