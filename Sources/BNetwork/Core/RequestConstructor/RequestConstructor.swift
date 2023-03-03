
import Foundation

public protocol BNetworkRequestConstructorProtocol {
    func buildRequest(from endPoint: BNetworkEndPointProtocol) async throws -> URLRequest
    @discardableResult func setTimeoutInterval(_ timeout: Double) -> Self
}

public extension BNetwork {
    struct RequestConstructor: BNetworkRequestConstructorProtocol {
        var timeoutInterval: Double = defaultTimeoutInterval
        
        public func buildRequest(from endPoint: BNetworkEndPointProtocol) async throws -> URLRequest {
            var request = URLRequest(url: endPoint.url.appendingPathComponent(endPoint.path),
                                     timeoutInterval: timeoutInterval)
            
            request.httpMethod = endPoint.method.rawValue
            
            do {
                switch endPoint.task {
                case .request:
                    if let baseHeaders = endPoint.headers {
                        self.addAdditionalHeaders(baseHeaders, request: &request)
                    }
                    
                case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                    if let baseHeaders = endPoint.headers {
                        self.addAdditionalHeaders(baseHeaders, request: &request)
                    }
                    
                    try self.configureParameters(bodyParameters: bodyParameters,
                                                 bodyEncoding: bodyEncoding,
                                                 urlParameters: urlParameters,
                                                 request: &request)
                    
                case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionalHeaders):
                    if let baseHeaders = endPoint.headers {
                        self.addAdditionalHeaders(baseHeaders, request: &request)
                    }
                    
                    self.addAdditionalHeaders(additionalHeaders, request: &request)
                    
                    try self.configureParameters(bodyParameters: bodyParameters,
                                                 bodyEncoding: bodyEncoding,
                                                 urlParameters: urlParameters,
                                                 request: &request)
                    
                case .upload(bodyParameters: let bodyParameters):
                    if let baseHeaders = endPoint.headers {
                        self.addAdditionalHeaders(baseHeaders, request: &request)
                    }
                    
                    try self.configureParameters(bodyParameters: bodyParameters,
                                                 bodyEncoding: .multipart,
                                                 urlParameters: nil,
                                                 request: &request)
                }
                
                return request
            } catch let error {
                throw NetworkError(error: error)
            }
        }
        
        @discardableResult
        public func setTimeoutInterval(_ timeout: Double) -> Self {
            var new = self
            new.timeoutInterval = timeout
            
            return new
        }
    }
}

private extension BNetwork.RequestConstructor {
    typealias ParameterEncoding = BNetwork.ParameterEncoding
    typealias Parameters = BNetwork.Parameters
    typealias HTTPHeaders = BNetwork.HTTPHeaders
    typealias NetworkError = BNetwork.NetworkError
    
    func configureParameters(bodyParameters: Any?,
                             bodyEncoding: ParameterEncoding,
                             urlParameters: Parameters?,
                             request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch let error {
            throw NetworkError(error: error)
        }
    }
    
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
