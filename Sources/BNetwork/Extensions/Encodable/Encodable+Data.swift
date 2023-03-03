
import Foundation

public extension Encodable {
    func toData(outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> Data? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = outputFormatting
        
        do {
            let jsonData = try jsonEncoder.encode(self)
            return jsonData
        } catch let jsonErr {
            print("Encode error \n \(jsonErr)")
            return nil
        }
    }
}
