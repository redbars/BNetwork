
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension BNetwork {
    struct ResponseData {
        public var body: Data?
        
        public var request: URLRequest?
        public var response: URLResponse?
        
        public init(body: Data?,
                    request: URLRequest?,
                    response: URLResponse?) {
            self.body = body
            self.request = request
            self.response = response
        }
    }
}

public extension BNetwork.ResponseData {
    var httpURLResponse: HTTPURLResponse? {
        return response as? HTTPURLResponse
    }
    
    var statusCode: BNetwork.HttpStatus {
        return BNetwork.HttpStatus(rawValue: httpURLResponse?.statusCode ?? 0) ?? .unknown
    }
    
    var headers: [String:String] {
        return (httpURLResponse?.allHeaderFields as? [String:String]) ?? [:]
    }
}
