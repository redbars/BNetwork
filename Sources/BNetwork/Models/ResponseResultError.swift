
import Foundation

public extension BNetwork {
    struct ResponseResultError<T: Decodable>: Error {
        public let errors: T?
        public let otherErrors: [NetworkError]?
        public var responseData: ResponseData?
        
        public init(errors: T?,
                    otherErrors: [NetworkError]?,
                    responseData: ResponseData?) {
            self.errors = errors
            self.otherErrors = otherErrors
            self.responseData = responseData
        }
    }
}
