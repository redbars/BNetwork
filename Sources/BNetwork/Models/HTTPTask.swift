
import Foundation

public extension BNetwork {
    enum HTTPTask {
        case request
        case requestParameters(body: Any?,
                               bodyEncoding: ParameterEncoding,
                               urlParameters: Parameters?)
        case requestParametersAndHeaders(body: Any?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         additionHeaders: HTTPHeaders?)
        case upload(bodyParameters: Parameters?)
    }
}
