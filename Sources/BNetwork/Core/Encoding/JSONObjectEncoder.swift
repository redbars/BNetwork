
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol BNetworkObjectEncoderProtocol {
    func encode(urlRequest: inout URLRequest, with object: Any) throws
}

extension BNetwork {
    struct JSONObjectEncoder: BNetworkObjectEncoderProtocol {
        func encode(urlRequest: inout URLRequest, with object: Any) throws {
            do {
                guard JSONSerialization.isValidJSONObject(object) else {  throw NetworkError.encodingFailed }
                
                let jsonAsData = try JSONSerialization.data(withJSONObject: object, options: [])
                urlRequest.httpBody = jsonAsData
                
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch let error {
                throw NetworkError(error: error)
            }
        }
    }
}
