//
//  APIEndpoint.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIEndpoint<Object> {
    public var api: API
    public var method: APIMethod
    public var path: String = ""
    public var parameters: APIParameters
    
    public init(api: API = .latest, method: APIMethod = .get, path: String, parameters: APIParameters = [:]) {
        self.api = api
        self.method = method
        self.parameters = parameters
        append(path)
    }
}


extension APIEndpoint {
    mutating func append(_ pathComponents: String...) {
        for component in pathComponents {
            if path.last != "/" && component.first != "/" {
                path.append("/")
            }
            
            if component.isEmpty {
                continue
            }
            
            path.append(component.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
        }
    }
}
