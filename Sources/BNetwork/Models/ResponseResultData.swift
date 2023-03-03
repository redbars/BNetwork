
import Foundation

public extension BNetwork {
    struct ResponseResultData<T: Decodable> {
        public var responseData: ResponseData?
        public var body: T?
        
        public init(responseData: ResponseData?,
                    body: T?) {
            self.responseData = responseData
            self.body = body
        }
    }
}


public extension BNetwork {
    struct ResponseResultDataAsync<A: Decodable, B: Decodable> {
        public var responseData: ResponseData?
        public var dataBody: A?
        public var errorBody: B?
        
        public init(responseData: ResponseData?,
                    dataBody: A?,
                    errorBody: B?) {
            self.responseData = responseData
            self.dataBody = dataBody
            self.errorBody = errorBody
        }
    }
}
