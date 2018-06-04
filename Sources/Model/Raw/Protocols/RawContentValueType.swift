//
//  RawContentValueType.swift
//  Peanut
//
//  Created by Shawn Throop on 02.06.18.
//

public protocol RawContentValueType: RawContentKeyDecodable {
    var unvalidatedContent: RawUnvalidatedContent { get set }
}


extension RawContentValueType {
    public subscript<T: Encodable & Equatable>(unvalidated key: Identifier<RawContent>) -> T? {
        get {
            return self[unvalidated: key] as? T
        }
        set {
            unvalidatedContent[key] = newValue
        }
    }
    
    public subscript(unvalidated key: Identifier<RawContent>) -> Any? {
        get {
            return unvalidatedContent[key]
        }
    }
}


extension KeyedDecodingContainer where K == Identifier<RawContent> {
    public func decodeUnvalidatedContent<T: RawContentKeyDecodable>(for type: T.Type) throws -> AnyDictionary<K> {
        return try decodeUnvalidatedContent(excludedKeys: T.validDecodableKeys)
    }
    
    public func decodeUnvalidatedContent(excludedKeys keys: Set<K>?) throws -> AnyDictionary<K> {
        return try AnyDictionary(from: self, excluding: keys)
    }
}


extension KeyedEncodingContainer where K == Identifier<RawContent> {
    public mutating func encodeUnvalidatedContent(_ content: AnyDictionary<K>) throws {
        try content.encode(to: &self)
    }
}
