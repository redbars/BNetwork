
import Foundation

public extension BNetwork {
    struct NetworkError: Error {
        public var key: String
        public var value: String
        public var context: Any?
        
        public init(key: String,
                    value: String,
                    context: Any? = nil) {
            self.key = key
            self.value = value
            self.context = context
        }
        
        public init(error: Error) {
            if let error = error as? NetworkError {
                self.key = error.key
                self.value = error.value
                self.context = error.context
            } else {
                self.key = "error"
                self.value = error.localizedDescription
                self.context = error
            }
        }
    }
}

public extension BNetwork.NetworkError {
    typealias NetworkError = BNetwork.NetworkError
    
    static var unknownError: NetworkError {
        return NetworkError(key: "unknownError",
                            value: "Unknown Error")
    }
    
    static var serverError: NetworkError {
        return NetworkError(key: "serverError",
                            value: "Server error")
    }
    
    static var parametersNil: NetworkError {
        return NetworkError(key: "parametersNil",
                            value: "Parameters were nil")
    }
    
    static var encodingFailed: NetworkError {
        return NetworkError(key: "encodingFailed",
                            value: "Encoding failed")
    }
    
    static func decodingFailed(description: String = "Decoding failed") -> NetworkError {
        return NetworkError(key: "decodingFailed",
                            value: description)
    }
    
    static var missingURL: NetworkError {
        return NetworkError(key: "missingURL",
                            value: "URL is nil.")
    }
}
