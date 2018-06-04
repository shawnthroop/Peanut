//
//  AnyDictionary.swift
//  Peanut
//
//  Created by Shawn Throop on 30.05.18.
//

public struct AnyDictionary<Key: AnyDictionaryKey>: Equatable {
    public static var empty: AnyDictionary {
        return AnyDictionary()
    }
    
    fileprivate var storage: [String: EncodableValue] = [:]
    
    public init() {}
}


extension AnyDictionary where Key: Hashable {
    public init(_ content: [Key: EncodableValue]) {
        for (key, value) in content {
            storage[key.keyValue] = value
        }
    }
}


extension AnyDictionary {
    public subscript<V>(key: Key) -> V? where V : Encodable & Equatable {
        get {
            return self[key] as? V
        }
        set {
            storage[key.keyValue] = newValue.map { EncodableValue($0) }
        }
    }
    
    public subscript(key: Key) -> Any? {
        return storage[key.keyValue]?.base
    }
}


extension AnyDictionary where Key: CodingKey & Hashable {
    public init<S: Sequence>(from container: KeyedDecodingContainer<Key>, excluding keys: S? = nil) throws where S.Element == Key {
        let allKeys = Set(container.allKeys)
        
        for key in keys.map({ allKeys.subtracting($0) }) ?? allKeys {
            storage[key.stringValue] = try container.decode(EncodableValue.self, forKey: key)
        }
    }
}


extension AnyDictionary where Key: CodingKey {
    public func encode(to container: inout KeyedEncodingContainer<Key>) throws {
        for (k, value) in storage {
            try container.encode(value, forKey: Key(keyValue: k))
        }
    }
}


extension AnyDictionary: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        storage = try container.decode([String: EncodableValue].self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(storage)
    }
}


extension AnyDictionary: Sequence {
    public typealias Element = (key: Key, value: Any)
    public typealias Iterator = AnyIterator<Element>
    
    public func makeIterator() -> AnyIterator<Element> {
        var iterator = storage.makeIterator()
        
        return AnyIterator {
            return iterator.next().map { Element(key: Key(keyValue: $0.key), value: $0.value.base) }
        }
    }
}


extension AnyDictionary: Collection {

    public struct Index: Comparable {
        public static func < (lhs: AnyDictionary<Key>.Index, rhs: AnyDictionary<Key>.Index) -> Bool {
            return lhs.base < rhs.base
        }
        
        fileprivate let base: Dictionary<String, EncodableValue>.Index
        
        fileprivate init(_ base: Dictionary<String, EncodableValue>.Index) {
            self.base = base
        }
    }
    
    public var startIndex: Index {
        return Index(storage.startIndex)
    }
    
    public var endIndex: Index {
        return Index(storage.endIndex)
    }
    
    public func index(after i: Index) -> Index {
        return Index(storage.index(after: i.base))
    }
    
    public subscript(position: Index) -> Element {
        let (k, v) = storage[position.base]
        return (key: Key(keyValue: k), value: v.base)
    }
    
    public var underestimatedCount: Int {
        return storage.underestimatedCount
    }
    
    public var count: Int {
        return storage.count
    }
}


extension AnyDictionary: CustomStringConvertible {
    public var description: String {
        return storage.description
    }
}


internal extension KeyedEncodingContainer where K == Identifier<RawContent> {
    mutating func encodeIfPresent(_ value: AnyDictionary<K>?) throws {
        guard let storage = value?.storage else {
            return
        }
        
        for (k, v) in storage {
            try encode(v, forKey: K(keyValue: k))
        }
    }
}
