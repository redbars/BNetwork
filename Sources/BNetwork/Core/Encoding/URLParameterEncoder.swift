
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BNetwork {
    struct URLParameterEncoder: BNetworkParameterEncoderProtocol {
        func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
            guard let url = urlRequest.url else { throw NetworkError.missingURL }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let urlEncoding: Bool = true
                
                urlComponents.queryItems = [URLQueryItem]()
                
                for (key,value) in parameters {
                    let queryItem = URLQueryItem(name: key, value: "\(value)")
                    urlComponents.queryItems?.append(queryItem)
                }
                
                urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?
                    .replacingOccurrences(of: "+", with: "%2B")
                    .replacingOccurrences(of: "/", with: "%2F")
                
                if urlEncoding {
                    urlRequest.url = urlComponents.url
                } else {
                    urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
                    
                    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    }
                }
            }
        }
    }
}
