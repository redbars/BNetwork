
import Foundation

public protocol BNetworkDecodingProtocol {
    func decode<T: Decodable>(data: Data?) throws -> T
}

public extension BNetwork {
    struct Decoder: BNetworkDecodingProtocol {
        public func decode<T: Decodable>(data: Data?) throws -> T {
            guard let data = data else {
                throw NetworkError.decodingFailed(description: "Decoding failed. Data is empty")
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = BNetwork.keyDecodingStrategy
                
                let result = try decoder.decode(T.self,
                                                from: data)
                
                return result
            } catch let error {
                if T.self == Nothing?.self || T.self == Nothing.self {
                    return Nothing() as! T
                }
                
                throw NetworkError(error: error)
            }
        }
    }
}
