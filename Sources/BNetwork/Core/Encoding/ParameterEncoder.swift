
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension BNetwork {
    typealias HTTPHeaders = [String : String]
    typealias Parameters = [String : Any]
}

public extension BNetwork {
    enum ParameterEncoding {
        case urlEncoding
        case jsonEncoding
        case urlAndJsonEncoding
        case multipart
        case urlAndMultipartEncoding
        
        func encode(urlRequest: inout URLRequest,
                    bodyParameters: Any?,
                    urlParameters: Parameters?) throws {
            do {
                switch self {
                case .urlEncoding:
                    if let urlParameters = urlParameters {
                        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                    }
                    
                case .jsonEncoding:
                    if let bodyParameters = bodyParameters {
                        if let parameters = bodyParameters as? Parameters {
                            try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
                        } else {
                            try JSONObjectEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                        }
                    }
                    
                case .urlAndJsonEncoding:
                    if let bodyParameters = bodyParameters {
                        if let parameters = bodyParameters as? Parameters {
                            try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
                        } else {
                            try JSONObjectEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
                        }
                    }
                    
                    if let urlParameters = urlParameters {
                        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                    }
                    
                case .multipart:
                    if let bodyParameters = bodyParameters {
                        if let parameters = bodyParameters as? Parameters {
                            try MultipartParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
                        }
                    }
                    
                case .urlAndMultipartEncoding:
                    if let bodyParameters = bodyParameters {
                        if let parameters = bodyParameters as? Parameters {
                            try MultipartParameterEncoder().encode(urlRequest: &urlRequest, with: parameters)
                        }
                    }
                    
                    if let urlParameters = urlParameters {
                        try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                    }
                }
            } catch let error {
                throw NetworkError(error: error)
            }
        }
    }
}
