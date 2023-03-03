
import Foundation

public extension BNetworkEndPointProtocol {
    func toEndPoint() -> BNetwork.EndPoint {
        let ep = BNetwork.EndPoint()
            .setEnvironment(environment)
            .setURL(url)
            .setPath(path)
            .setMethod(method)
            .setTask(task)
            .setHeaders(headers)
        return ep
    }
}
