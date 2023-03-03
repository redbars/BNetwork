
import Foundation

public extension Encodable {
    func toDictionary(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = BNetwork.keyEncodingStrategy) -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
