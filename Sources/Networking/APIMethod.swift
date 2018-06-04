//
//  APIMethod.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// Possible HTTP methods
public enum APIMethod: Hashable, Codable {
    case get
    case post
    case put
    case patch
    case delete
}


extension APIMethod: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "get":
            self = .get
        case "post":
            self = .post
        case "put":
            self = .put
        case "patch":
            self = .patch
        case "delete":
            self = .delete
            
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .get:
            return "get"
        case .post:
            return "post"
        case .put:
            return "put"
        case .patch:
            return "patch"
        case .delete:
            return "delete"
        }
    }
}
