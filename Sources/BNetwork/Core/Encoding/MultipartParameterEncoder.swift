
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension BNetwork {
    struct MultipartParameterEncoder: BNetworkParameterEncoderProtocol {
        func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
            let boundary = UUID().uuidString
            var data = Data()
            
            (parameters.filter { $0.value is String } as? [String: String])?
                .forEach {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n".data(using: .utf8)!)
                    data.append("\($0.value)".data(using: .utf8)!)
                }
            
            (parameters.filter { $0.value is BNetwork.MultipartData } as? [String: BNetwork.MultipartData])?
                .forEach {
                    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                    data.append("Content-Disposition: form-data; name=\"\($0.key)\"; filename=\"\($0.key).\($0.value.ext)\"\r\n".data(using: .utf8)!)
                    data.append("Content-Type: \($0.value.type)\r\n\r\n".data(using: .utf8)!)
                    data.append($0.value.data)
                }
            
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = data
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        }
    }
}
