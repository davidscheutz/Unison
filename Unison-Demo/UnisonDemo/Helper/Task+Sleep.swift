import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async {
        try? await sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
