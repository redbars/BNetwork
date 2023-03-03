
import Foundation

public protocol BNetworkEndPointPathProtocol {
    func url(_ environment: BNetwork.Environment) -> URL
    var path: String { get }
}
