//
//  APIStatusCode.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// Currently used HTTP status codes
public enum APIStatusCode: Int, Hashable, Codable {
    case ok                     = 200
    case success                = 201
    case noContent              = 204
    case found                  = 302
    case badRequest             = 400
    case unauthorized           = 401
    case forbidden              = 403
    case notFound               = 404
    case tooManyRequests        = 429
    case internalServerError    = 500
    case insufficientStorage    = 507
}


extension APIStatusCode: CustomStringConvertible {
    public var description: String {
        return "(\(rawValue)) \(englishDescription)"
    }
    
    public var englishDescription: String {
        switch self {
        case .ok:
            return "Ok"
        case .success:
            return "Success"
        case .noContent:
            return "No Content"
        case .found:
            return "Found"
        case .badRequest:
            return "Bad Request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not Found"
        case .tooManyRequests:
            return "Too Many Requests"
        case .internalServerError:
            return "Internal Server Error"
        case .insufficientStorage:
            return "Insufficient Storage"
        }
    }
}
