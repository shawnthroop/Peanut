//
//  APIMethod.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// Possible HTTP methods
public enum APIMethod: String, Hashable {
    case get
    case post
    case put
    case patch
    case delete
}
