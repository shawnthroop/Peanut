//
//  APIEncodingContext.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIEncodingContext: Hashable {
    public var api: API
    public var destination: APIFormat
    
    public init(api: API = .latest, destination: APIFormat) {
        self.api = api
        self.destination = destination
    }
}


extension Encoder {
    public var context: APIEncodingContext? {
        return userInfo[.encodingContext] as? APIEncodingContext
    }
}


extension JSONEncoder {
    public convenience init(context: APIEncodingContext) {
        self.init()
        userInfo[.encodingContext] = context
        dateEncodingStrategy = .iso8601
    }
    
    public convenience init(destination format: APIFormat) {
        self.init(context: APIEncodingContext(destination: format))
    }
}


private extension CodingUserInfoKey {
    static let encodingContext = CodingUserInfoKey(rawValue: "com.throop.Peanut.coding.encodingContext")!
}
