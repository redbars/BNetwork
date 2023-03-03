
import Foundation

public extension String {
    func jsonToData() -> Data? {
        return  self.data(using: String.Encoding.utf8)
    }
    
    func jsonToObject<T: Decodable>() -> T? {
        guard let jsonData = jsonToData() else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: jsonData)
            return result
        } catch let jsonErr {
            print("Decode error \n \(jsonErr)")
            return nil
        }
    }
}
