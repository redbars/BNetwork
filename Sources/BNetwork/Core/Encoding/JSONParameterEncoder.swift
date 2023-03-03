
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol BNetworkParameterEncoderProtocol {
    typealias Parameters = BNetwork.Parameters
    
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

extension BNetwork {
    struct JSONParameterEncoder: BNetworkParameterEncoderProtocol {
        func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
            do {
                guard JSONSerialization.isValidJSONObject(parameters) else {  throw
                    NetworkError.encodingFailed }
                
                let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: [])
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

private extension JSONEncoder {
    typealias Parameters = BNetwork.Parameters
    
    func toBodyParameters<T:Codable>(item: T) -> Parameters {
        guard
            let encode = try? JSONEncoder().encode(item),
            let params = try? JSONSerialization.jsonObject(with: encode, options: []) as? Parameters
        else { return [:] }
        
        return params
    }
}
