
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol BNetworkRequestProtocol {
    typealias ResponseResultData<T: Decodable> = BNetwork.ResponseResultData<T>
    typealias ResponseResultDataAsync<A: Decodable, B: Decodable> = BNetwork.ResponseResultDataAsync<A,B>
    typealias ResponseResultError<T: Decodable> = BNetwork.ResponseResultError<T>
    
    var requestConstructor: BNetworkRequestConstructorProtocol { get }
    var decoder: BNetworkDecodingProtocol { get }
    
//    func request<A,B>(_ endPoint: BNetworkEndPointProtocol) -> AnyPublisher<ResponseResultData<A>, ResponseResultError<B>> where A: Decodable, B: Decodable
    func request<A,B>(_ endPoint: BNetworkEndPointProtocol) async throws -> (ResponseResultDataAsync<A,B>) where A: Decodable, B: Decodable
}

public extension BNetwork {
    struct Request: BNetworkRequestProtocol {
        public let requestConstructor: BNetworkRequestConstructorProtocol
        public let decoder: BNetworkDecodingProtocol
        
        public init(requestConstructor: BNetworkRequestConstructorProtocol,
                    decoder: BNetworkDecodingProtocol) {
            self.requestConstructor = requestConstructor
            self.decoder = decoder
        }
        
        public init() {
            self.requestConstructor = RequestConstructor()
            self.decoder = Decoder()
        }
        
        public func request<A,B>(_ endPoint: BNetworkEndPointProtocol) async throws -> (ResponseResultDataAsync<A,B>) where A: Decodable, B: Decodable {
            let request = try await requestConstructor.buildRequest(from: endPoint)
            
#if canImport(FoundationNetworking)
            let (data, response) = await withCheckedContinuation { continuation in
                    URLSession.shared.dataTask(with: request) { data, response, _ in
                        continuation.resume(returning: (data, response))
                    }.resume()
                }
#else
            let (data, response) = try await URLSession.shared.datawithTaskCancellation(with: request)
#endif
            
            let responseData = ResponseData(body: data,
                                            request: request,
                                            response: response)
            
            let statusCode = responseData.statusCode.rawValue
            
            func getResultBody() async throws -> A {
                return try self.decoder.decode(data: responseData.body)
            }
            
            func getErrorBody() async throws -> B {
                return try self.decoder.decode(data: responseData.body)
            }
            
            let resultData: ResponseResultDataAsync<A,B>
            
            switch statusCode {
            case 200..<300:
                resultData = await ResponseResultDataAsync<A,B>(responseData: responseData,
                                                                dataBody: try getResultBody(),
                                                                errorBody: try? getErrorBody())
                
            default:
                resultData = await ResponseResultDataAsync<A,B>(responseData: responseData,
                                                                dataBody: try? getResultBody(),
                                                                errorBody: try getErrorBody())
            }
            
            return resultData
        }
        
//        public func request<A,B>(_ endPoint: BNetworkEndPointProtocol) -> AnyPublisher<ResponseResultData<A>, ResponseResultError<B>> where A: Decodable, B: Decodable {
//            let request: URLRequest
//            
//            do {
//                request = try requestConstructor.buildRequest(from: endPoint)
//            }
//            catch let error {
//                return Fail(error: ResponseResultError(errors: nil,
//                                                       otherErrors: [NetworkError(error: error)],
//                                                       responseData: nil))
//                .eraseToAnyPublisher()
//            }
//            
//            return URLSession.shared
//                .dataTaskPublisher(for: request)
//                .map { output in
//                    return ResponseData(body: output.data,
//                                        request: request,
//                                        response: output.response)
//                }
//                .tryMap { responseData in
//                    if responseData.statusCode == .unauthorized {
//                        let error: ResponseResultError<B> = ResponseResultError(errors: nil,
//                                                                                otherErrors: [NetworkError(key: "statusCode",
//                                                                                                           value: "\(responseData.statusCode.rawValue)")],
//                                                                                responseData: responseData)
//                        throw error
//                    }
//                    //                    else {
//                    //                        var isConnectionError: Bool = false
//                    //
//                    //                        switch (error as NSError).code {
//                    //                        case NSURLErrorCannotConnectToHost,
//                    //                             NSURLErrorNetworkConnectionLost,
//                    //                             NSURLErrorNotConnectedToInternet,
//                    //                             NSURLErrorDataNotAllowed:
//                    //                            isConnectionError = true
//                    //
//                    //                        default:
//                    //                            isConnectionError = false
//                    //                        }
//                    //                    }
//                    
//                    func getResultBody() throws -> A {
//                        return try self.decoder.get(data: responseData.body)
//                    }
//                    
//                    func getErrorBody() throws -> B {
//                        return try self.decoder.get(data: responseData.body)
//                    }
//                    
//                    do {
//                        let statusCode = responseData.statusCode.rawValue
//                        
//                        switch statusCode {
//                        case 200..<300:
//                            let resultData = ResponseResultData<A>(responseData: responseData,
//                                                                   body: try getResultBody())
//                            
//                            return resultData
//                            
//                        default:
//                            let error = ResponseResultError(errors: try getErrorBody(),
//                                                            otherErrors: nil,
//                                                            responseData: responseData)
//                            
//                            throw error
//                        }
//                    }
//                    catch let error {
//                        throw error
//                    }
//                }
//                .mapError({ error in
//                    if let error = error as? ResponseResultError<B> {
//                        return error
//                    } else {
//                        return ResponseResultError(errors: nil,
//                                                   otherErrors: [NetworkError(error: error)],
//                                                   responseData: nil)
//                    }
//                })
//                .eraseToAnyPublisher()
//        }
    }
}

extension URLSession {
    @available(iOS, deprecated: 15, message: "Use `data(for:delegate:)` instead")
    @available(macOS, deprecated: 12, message: "Use `data(for:delegate:)` instead")
    func datawithTaskCancellation(with request: URLRequest) async throws -> (Data, URLResponse) {
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

private extension URLSession {
    actor SessionTask {
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

// MARK: Data

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
    enum State {
        case ready
        case executing(URLSessionTask)
        case cancelled
    }
}

//extension URLSession {
//    @available(iOS, deprecated: 15, message: "Use `download(from:delegate:)` instead")
//    @available(macOS, deprecated: 12, message: "Use `download(from:delegate:)` instead")
//    func downloadwithTaskCancellation(with url: URL) async throws -> (URL, URLResponse) {
//        try await downloadwithTaskCancellation(with: URLRequest(url: url))
//    }
//
//    @available(iOS, deprecated: 15, message: "Use `download(for:delegate:)` instead")
//    @available(macOS, deprecated: 12, message: "Use `download(for:delegate:)` instead")
//    func downloadwithTaskCancellation(with request: URLRequest) async throws -> (URL, URLResponse) {
//        let sessionTask = SessionTask(session: self)
//
//        return try await withTaskCancellationHandler {
//            try await withCheckedThrowingContinuation { continuation in
//                Task {
//                    await sessionTask.download(for: request) { location, response, error in
//                        guard let location, let response else {
//                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
//                            return
//                        }
//
//                        // since continuation can happen later, let’s figure out where to store it ...
//
//                        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
//                            .appendingPathComponent(UUID().uuidString)
//                            .appendingPathExtension(request.url!.pathExtension)
//
//                        // ... and move it to there
//
//                        do {
//                            try FileManager.default.moveItem(at: location, to: tempURL)
//                        } catch {
//                            continuation.resume(throwing: error)
//                            return
//                        }
//
//                        continuation.resume(returning: (tempURL, response))
//                    }
//                }
//            }
//        } onCancel: {
//            Task { await sessionTask.cancel() }
//        }
//    }
//}

//extension URLSession.SessionTask {
//    func download(for request: URLRequest, completionHandler: @Sendable @escaping (URL?, URLResponse?, Error?) -> Void) {
//        if case .cancelled = state {
//            completionHandler(nil, nil, CancellationError())
//            return
//        }
//
//        let task = session.downloadTask(with: request, completionHandler: completionHandler)
//
//        state = .executing(task)
//        task.resume()
//    }
//}
