
import Foundation

extension URLSession {
    @available(iOS, deprecated: 15, message: "Use `data(for:delegate:)` instead")
    @available(macOS, deprecated: 12, message: "Use `data(for:delegate:)` instead")
    func dataWithTaskCancellation(with request: URLRequest) async throws -> (Data, URLResponse) {
        let sessionTask = SessionTask(session: self)

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                Task {
                    await sessionTask.data(for: request) { data, response, error in
                        guard let data, let response else {
                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            return
                        }

                        continuation.resume(returning: (data, response))
                    }
                }
            }
        } onCancel: {
            Task { await sessionTask.cancel() }
        }
    }
}
