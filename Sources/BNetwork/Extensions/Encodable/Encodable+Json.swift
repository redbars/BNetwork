
import Foundation

public extension Encodable {
    func toJsonString(encoding: String.Encoding = .utf8) -> String? {
        guard let jsonData = self.toData() else { return nil }
        
        return String(data: jsonData, encoding: encoding)
    }
}
