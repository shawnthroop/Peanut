//
//  APIError.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// Possible errors for any API request
public enum APIError {
    case network(URLError)
    case response(APIResponseError)
    case parse(DecodingError)
    case other(Swift.Error)
}
