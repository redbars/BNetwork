
import Foundation

public extension BNetwork {
    struct EndPoint: BNetworkEndPointProtocol {
        private var _endPointPath: BNetworkEndPointPathProtocol?
        private var _environment: Environment?
        private var _url: URL?
        private var _path: String?
        private var _method: HTTPMethod?
        private var _task: HTTPTask?
        private var _headers: HTTPHeaders?
        private var _mockResponseData: Data?
        
        public init() { }
        
        public var endPointPath: BNetworkEndPointPathProtocol? {
            return _endPointPath
        }
        
        public var environment: BNetwork.Environment {
            return _environment ?? .prod
        }
        
        public var url: URL {
            return _url ?? URL(string: "https://google.com")!
        }
        
        public var path: String {
            return _path ?? ""
        }
        
        public var method: HTTPMethod {
            return _method ?? .get
        }
        
        public var task: HTTPTask {
            return _task ?? .request
        }
        
        public var headers: HTTPHeaders? {
            return _headers ?? HTTPHeaders()
        }
        
        public var mockResponseData: Data? {
            return _mockResponseData
        }
    }
}

extension BNetwork.EndPoint {
    @discardableResult
    public func setEndpointPath(_ endPointPath: BNetworkEndPointPathProtocol) -> Self {
        var new = self
        new._endPointPath = endPointPath
        
        new = new.setURL(endPointPath.url(new.environment))
        new = new.setPath(endPointPath.path)
        
        return new
    }
    
    @discardableResult
    public func setEnvironment(_ environment: BNetwork.Environment) -> Self {
        var new = self
        new._environment = environment
        
        if let endPointPath = _endPointPath {
            new = new.setURL(endPointPath.url(new.environment))
        }
        
        return new
    }
    
    @discardableResult
    public func setURL(_ url: URL) -> Self {
        var new = self
        new._url = url
        
        return new
    }
    
    @discardableResult
    public func setPath(_ path: String) -> Self {
        var new = self
        new._path = path
        
        return new
    }
    
    @discardableResult
    public func setMethod(_ method: BNetwork.HTTPMethod) -> Self {
        var new = self
        new._method = method
        
        return new
    }
    
    @discardableResult
    public func setTask(_ task: BNetwork.HTTPTask) -> Self {
        var new = self
        new._task = task
        
        return new
    }
    
    @discardableResult
    public func setHeaders(_ headers: BNetwork.HTTPHeaders?) -> Self {
        var new = self
        new._headers = headers
        
        return new
    }
    
    @discardableResult
    public func setMockResponse(_ data: Data?) -> Self {
        var new = self
        new._mockResponseData = data
        
        return new
    }
}

