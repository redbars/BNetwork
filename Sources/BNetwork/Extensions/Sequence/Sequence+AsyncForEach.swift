//	Created by boris on 16.02.2023.
//	Copyright © 2023 All rights reserved.

import Foundation

public extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
