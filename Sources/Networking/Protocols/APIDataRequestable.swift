//
//  APIDataRequestable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIDataRequestable: APIRequestable where Response == APIDataResponse<Object>  {
    
    /// The type of object returned by the endpoint.
    associatedtype Object: Decodable & APIDefaultParametersProvider
}
