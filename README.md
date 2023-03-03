# BNetwork

### 1. Create Endpotint path:
```
enum AuthEndPointPath {
  case signUpWithLogin
  case signOut
}

extension AuthEndPointPath: EndPointPathProtocol {
    func url(_ environment: NetworkEnvironment) -> URL {
        return Config.apiUrl
    }
    
    var path: String {
        switch self {
        case .signUpWithLogin: return "/auth/sign-up"
        case .signOut: return "/auth/sign-out"
        }
    }
}
```


### 2. Create Endpotint request:

###### Create Endpotint request with json body:
```
public func signUpWithLogin(data: RequestModel) async throws -> ResponceModel {
  let body: [String: Any] = data.toDictionary() ?? [:]
        
  let endpoint = EndPoint()
      .setURL(Config.apiUrl)
      .setEndpointPath(AuthEndPointPath.signUpWithLogin)
      .setMethod(.post)
      .setTask(.requestParameters(body: body,
                                  bodyEncoding: .jsonEncoding,
                                  urlParameters: nil))
      .setHeaders(Config.Headers.baseHeaders)
        
   return try await endpoint.asyncRequest()
}
```

###### Create Endpotint request with url params:
```
public func signUpWithLogin(data: RequestModel) async throws -> ResponceModel {
  let params: [String: Any] = data.toDictionary() ?? [:]
        
  let endpoint = EndPoint()
      .setURL(Config.apiUrl)
      .setEndpointPath(AuthEndPointPath.signUpWithLogin)
      .setMethod(.post)
      .setTask(.requestParameters(body: nil,
                                  bodyEncoding: .urlEncoding,
                                  urlParameters: params))
      .setHeaders(Config.Headers.baseHeaders)
        
   return try await endpoint.asyncRequest()
}
```

###### Create Endpotint request without data:
```
public func signOut() async throws -> ResponceModel {
  let endpoint = EndPoint()
      .setURL(Config.apiUrl)
      .setEndpointPath(AuthEndPointPath.signUpWithLogin)
      .setMethod(.post)
      .setTask(.request())
      .setHeaders(Config.Headers.baseHeaders)
        
   return try await endpoint.asyncRequest()
}
```

###### Create Endpotint request without data:
```
public func signOut() async throws -> ResponceModel {
  let endpoint = EndPoint()
      .setURL(Config.apiUrl)
      .setEndpointPath(AuthEndPointPath.signUpWithLogin)
      .setMethod(.post)
      .setTask(.request())
      .setHeaders(Config.Headers.baseHeaders)
        
   return try await endpoint.asyncRequest()
}
```

###### Create Endpotint request without data:

Use MultipartData:
```
let image: Data!
let uploadData = MultipartData.image_jpg(image)
```

```
public func upload(data: MultipartData) async throws -> ResponceModel {
  let endpoint = EndPoint()
      .setURL(Config.apiUrl)
      .setEndpointPath(FilesEndPointPath.upload)
      .setMethod(.post)
      .setTask(.upload(bodyParameters: ["data":data]))
      .setHeaders(Config.Headers.baseHeaders)
        
      return try await endpoint.asyncRequest()
}
```

###### Use request in code:

```
let value = try await requests.signUpWithLogin(data: data)
self.authToken = value.authToken
```
or
```
let _ = try await requests.signOut()
```

###### For example:
```
A - Codable model for succses responce
B - Codable model for error responce
```
```
extension EndPoint {
  func asyncRequest<A:Decodable>() async throws -> A {
    typealias B = ErrorsResponse
    
    let result: ResponseResultDataAsync<T,B> = try await Request()
      .request(self)

    if let errorBody = result.errorBody {
      throw ...
    } else if let dataBody = result.dataBody {
      return dataBody
    } else {
      throw ...
    }
  }
}
```

```
Config.apiUrl -> URL(string: "https://example.com")
Config.Headers.baseHeaders -> ["Authorization":"{Token}"]
```
