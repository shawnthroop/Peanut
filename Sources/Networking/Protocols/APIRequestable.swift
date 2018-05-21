//
//  APIRequestable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIRequestable {
    
    /// The type of response returned by the endpoint
    associatedtype Response: Decodable & APIDefaultParametersProvider
    
    /// The endpoint representation for a given API
    func endpoint(for api: API) -> APIEndpoint<Response>
    
    ///  The payload for a given API. Default implementation returns `nil`
    func payload(for api: API) throws -> APIPayload?
}


extension APIRequestable {
    public typealias Request = APIRequest<Response>
    
    public func request(for api: API = .latest, parameters: APIParameters = [:], token: String? = nil, pagination: APIPagination? = nil) -> Request {
        var encodedPayload: APIPayload?
        
        do {
            encodedPayload = try payload(for: api)
        } catch {
            print(error)
        }
        
        return Request(endpoint: endpoint(for: api), parameters: parameters, token: token, payload: encodedPayload, pagination: pagination)
    }
    
    
    // Default implementation
    
    public func payload(for api: API) throws -> APIPayload? {
        return nil
    }
}
