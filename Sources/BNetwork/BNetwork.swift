
import Foundation

public var defaultTimeoutInterval: Double = 30
public var defaultRetyCount: Int = 1

public struct BNetwork {
    public static var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys
    public static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
}
