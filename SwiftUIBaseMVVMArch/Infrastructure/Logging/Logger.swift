//
//  Logger.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import OSLog

/// A logging utility for the application
public enum AppLogger {
    
    // MARK: - Log Levels
    
    public enum Level: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .warning:
                return .default
            case .error:
                return .error
            }
        }
    }
    
    // MARK: - Log Categories
    
    public enum Category: String {
        case network = "Network"
        case ui = "UI"
        case data = "Data"
        case general = "General"
        
        fileprivate var osLog: OSLog {
            return OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.app.SwiftUIBaseMVVMArch", category: self.rawValue)
        }
    }
    
    // MARK: - Logging Methods
    
    /// Log a message with the specified level and category
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The log level
    ///   - category: The log category
    ///   - file: The file where the log was called
    ///   - function: The function where the log was called
    ///   - line: The line where the log was called
    public static func log(
        _ message: String,
        level: Level = .info,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(function) - \(message)"
        
        os_log(level.osLogType, log: category.osLog, "%{public}@", logMessage)
        
        #if DEBUG
        print("[\(level.rawValue)][\(category.rawValue)] \(logMessage)")
        #endif
    }
    
    // MARK: - Convenience Methods
    
    public static func debug(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    public static func info(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    public static func warning(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    public static func error(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, category: category, file: file, function: function, line: line)
    }
}
