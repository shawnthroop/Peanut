//
//  OembedValueType.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol OembedValueType {
    static var type: Identifier<Oembed> { get }
}


internal extension KeyedDecodingContainer where K == Identifier<RawContent> {
    func ensureType<T: OembedValueType>(matches oembed: T.Type, forKey key: K = .type) throws {
        let type = try decode(Identifier<Oembed>.self, forKey: key)
        
        guard type == T.type else {
            throw RawDecodingError.oembedTypeMismatch(oembed, type: type, codingPath: codingPath)
        }
    }
}


internal extension KeyedEncodingContainer where K == Identifier<RawContent> {
    mutating func encodeType<T: OembedValueType>(_ oembed: T.Type, forKey key: K = .type) throws {
        try encode(oembed.type, forKey: key)
    }
}

