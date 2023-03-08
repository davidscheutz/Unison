import Foundation

final class LoginApi {
    func login(username: String, password: String) async throws {
        // simulate API call
        try? await Task.sleep(nanoseconds: UInt64(2 * 1_000_000_000)) // 2 sec
        
        // test code
        if username == "unison" && password == "pass" {
            // success
        } else {
            throw NSError(domain: "Invalid credentials", code: 400)
        }
    }
}
