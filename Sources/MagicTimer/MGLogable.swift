

import Foundation

/// A type that make easy logging
protocol MGLogable {
    func log(message: String)
}

extension MGLogable {
    func log(message: String) {
        NSLog("\(Self.self): \(message)")
    }
}
