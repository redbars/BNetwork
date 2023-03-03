
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol BNetworkEndPointProtocol {
    var environment: BNetwork.Environment { get }
    var url: URL { get }
    var path: String { get }
    var method: BNetwork.HTTPMethod { get }
    var task: BNetwork.HTTPTask { get }
    var headers: BNetwork.HTTPHeaders? { get }
}

extension BNetworkEndPointProtocol {
    public func getURLRequest(requestConstructor: BNetworkRequestConstructorProtocol? = nil) async throws -> URLRequest? {
        let constructor: BNetworkRequestConstructorProtocol = requestConstructor ?? BNetwork.RequestConstructor()
        
        let urlRequest = try await constructor.buildRequest(from: self)
        return urlRequest
    }
}

extension BNetworkEndPointProtocol {
    public func requestUrl() async -> URL? {
        return try? await getURLRequest()?.url
    }
}
