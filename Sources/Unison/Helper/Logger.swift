import Foundation
import OSLog

internal final class Logger {
    
    static let log = OSLog(subsystem: "Unison", category: "**")
    
    static func log(_ message: StaticString, type: OSLogType = .default, _ args: Any...) {
        os_log(message, log: log, type: type, args)
    }
}
