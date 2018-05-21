//
//  APIDecodingCotext.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIDecodingContext: Hashable {
    public var api: API
    public var source: APIFormat
    
    public init(api: API = .latest, source: APIFormat) {
        self.api = api
        self.source = source
    }
}


extension Decoder {
    public var context: APIDecodingContext? {
        return userInfo[.decodingContext] as? APIDecodingContext
    }
}


extension JSONDecoder {
    public convenience init(context: APIDecodingContext) {
        self.init()
        userInfo[.decodingContext] = context
        dateDecodingStrategy = .iso8601
    }
    
    public convenience init(source format: APIFormat) {
        self.init(context: APIDecodingContext(source: format))
    }
}


private extension CodingUserInfoKey {
    static let decodingContext = CodingUserInfoKey(rawValue: "com.throop.Peanut.coding.decodingContext")!
}
