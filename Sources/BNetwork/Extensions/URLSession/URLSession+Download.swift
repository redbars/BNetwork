
import Foundation

extension URLSession {
    @available(iOS, deprecated: 15, message: "Use `download(from:delegate:)` instead")
    @available(macOS, deprecated: 12, message: "Use `download(from:delegate:)` instead")
    func downloadwithTaskCancellation(with url: URL) async throws -> (URL, URLResponse) {
        try await downloadwithTaskCancellation(with: URLRequest(url: url))
    }

    @available(iOS, deprecated: 15, message: "Use `download(for:delegate:)` instead")
    @available(macOS, deprecated: 12, message: "Use `download(for:delegate:)` instead")
    func downloadwithTaskCancellation(with request: URLRequest) async throws -> (URL, URLResponse) {
        let sessionTask = SessionTask(session: self)

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                Task {
                    await sessionTask.download(for: request) { location, response, error in
                        guard let location, let response else {
                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            return
                        }

                        // since continuation can happen later, let’s figure out where to store it ...

                        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                            .appendingPathComponent(UUID().uuidString)
                            .appendingPathExtension(request.url!.pathExtension)

                        // ... and move it to there

                        do {
                            try FileManager.default.moveItem(at: location, to: tempURL)
                        } catch {
                            continuation.resume(throwing: error)
                            return
                        }

                        continuation.resume(returning: (tempURL, response))
                    }
                }
            }
        } onCancel: {
            Task { await sessionTask.cancel() }
        }
    }
}
