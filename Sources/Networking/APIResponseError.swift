//
//  APIResponseError.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIResponseError: Hashable, Decodable {
    public var code: APIStatusCode
    public var message: String
    
    public init(code: APIStatusCode, message: String) {
        self.code = code
        self.message = message
    }
}


extension APIResponseError {
    internal enum CodingKeys: String, CodingKey {
        case code
        case message = "error_message"
    }
}
