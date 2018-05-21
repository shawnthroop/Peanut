//
//  APIRequest.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public class APIRequest<Object: APIDefaultParametersProvider> {
    public var endpoint: APIEndpoint<Object>
    public var token: String?
    public var payload: APIPayload?
    public var parameters: APIParameters
    public var pagination: APIPagination?
    
    public init(endpoint: APIEndpoint<Object>, parameters: APIParameters = [:], token: String?, payload: APIPayload?, pagination: APIPagination? = nil) {
        self.endpoint = endpoint
        self.parameters = parameters
        self.token = token
        self.payload = payload
        self.pagination = pagination
    }
    
    public func buildURLRequest() -> URLRequest {
        var req = URLRequest(url: buildURL())
        req.httpMethod = endpoint.method.rawValue.uppercased()
        
        if let token = token {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        payload?.add(to: &req)
        
        return req
    }
}


extension URLSession {
    public typealias APIRequestableObject = Decodable & APIDefaultParametersProvider
    
    public func data<T: APIRequestableObject>(for request: APIRequest<T>, completion: @escaping (APIResponse<T>) -> ()) {
        let api = request.endpoint.api
        
        let task = dataTask(with: request.buildURLRequest()) { data, response, error in
            completion(APIResponse<T>(remote: data, error: error, api: api))
        }
        
        task.resume()
    }
}


private extension APIRequest {
    func buildURL() -> URL {
        return URL(string: endpoint.api.root + buildPath())!
    }
    
    func buildPath() -> String {
        var result = endpoint.path
        
        if result.last == "/" {
            result.removeLast()
        }
        
        return result + buildQuery()
    }
    
    func buildQuery() -> String {
        var combinedParameters = endpoint.parameters
        
        if let paginationParameters = pagination?.parameters {
            combinedParameters.merge(paginationParameters, uniquingKeysWith: { $1 })
        }
        
        combinedParameters.merge(parameters, uniquingKeysWith: { $1 })
        
        var values = combinedParameters.rawValues
        values.subtract(Object.defaultParameters.rawValues)
        
        return values.asPercentEncodedQuery(withAllowedCharacters: .urlQueryAllowed)
    }
}


private extension Dictionary where Key == String, Value == String {
    mutating func subtract(_ other: Dictionary<Key,Value>) {
        for value in other {
            if let i = index(where: { $0 == value }) {
                remove(at: i)
            }
        }
    }
}


private extension APIPayload {
    func add(to request: inout URLRequest) {
        let contentType: String
        
        switch self {
        case .json(let data):
            request.httpBody = data
            contentType = "application/json"
            
        case .urlEncodedForm(let data):
            request.httpBody = data
            contentType = "application/x-www-form-urlencoded"
        }
        
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    }
}
