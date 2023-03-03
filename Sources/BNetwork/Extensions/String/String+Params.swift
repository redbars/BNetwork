
import Foundation

public extension String {
    func setParams(with parameters: [String: Any]) -> Self {
        var text = self
        parameters.forEach { (key, value) in
            text = text.replacingOccurrences(of: "{\(key)}", with: String(describing: value))
        }
        
        return text
    }
}
