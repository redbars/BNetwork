
import Foundation

extension URLSession {
    actor SessionTask {
        enum State {
            case ready
            case executing(URLSessionTask)
            case cancelled
        }
        
        var state: State = .ready
        private let session: URLSession

        init(session: URLSession) {
            self.session = session
        }

        func cancel() {
            if case .executing(let task) = state {
                task.cancel()
            }
            state = .cancelled
        }
    }
}

extension URLSession.SessionTask {
    func data(for request: URLRequest, completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) {
        if case .cancelled = state {
            completionHandler(nil, nil, CancellationError())
            return
        }

        let task = session.dataTask(with: request, completionHandler: completionHandler)

        state = .executing(task)
        task.resume()
    }
}

extension URLSession.SessionTask {
    func download(for request: URLRequest, completionHandler: @Sendable @escaping (URL?, URLResponse?, Error?) -> Void) {
        if case .cancelled = state {
            completionHandler(nil, nil, CancellationError())
            return
        }

        let task = session.downloadTask(with: request, completionHandler: completionHandler)

        state = .executing(task)
        task.resume()
    }
}
