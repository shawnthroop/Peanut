//
//  APIObjectRequestable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIObjectRequestable: APIRequestable where Response == APIObjectResponse<Object>  {
    
    /// The type of object returned by the endpoint.
    associatedtype Object: Decodable & APIDefaultParametersProvider
}
