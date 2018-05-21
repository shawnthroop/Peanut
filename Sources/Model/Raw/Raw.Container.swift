//
//  Raw.Container.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension Raw {
    
    public typealias ContainerKey = Identifier<Raw.Value>
    public typealias ContainerKeys = Set<ContainerKey>
    
    public struct Container: Equatable {
        fileprivate typealias Contents = [ContainerKey: ContainerValue]
        
        private var contents: Contents
        
        private init(contents: Contents) {
            self.contents = contents
        }
    }
}


extension Raw.Container {
    public init(rawValue: [String: Any]) {
        self.init(contents: rawValue.asContainerContents())
    }
    
    internal init(from container: KeyedDecodingContainer<Raw.ContainerKey>, filter isIncluded: (Raw.ContainerKey) -> Bool) throws {
        try self.init(contents: container.decode(Raw.Container.Contents.self, filter: isIncluded))
    }
    
    internal func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try container.encode(contents)
    }
}


extension Raw.Container: RawContainerType {
    public func decode(_ type: Bool.Type, forKey key: Raw.ContainerKey) -> Bool? {
        return self[raw: key]
    }
    
    public func decode(_ type: Int.Type, forKey key: Raw.ContainerKey) -> Int? {
        return self[raw: key]
    }
    
    public func decode(_ type: Double.Type, forKey key: Raw.ContainerKey) -> Double? {
        return self[raw: key]
    }
    
    public func decode(_ type: String.Type, forKey key: Raw.ContainerKey) -> String? {
        return self[raw: key]
    }
    
    public func decode(_ type: [Bool].Type, forKey key: Raw.ContainerKey) -> [Bool]? {
        return self[raw: key]
    }
    
    public func decode(_ type: [Int].Type, forKey key: Raw.ContainerKey) -> [Int]? {
        return self[raw: key]
    }
    
    public func decode(_ type: [Double].Type, forKey key: Raw.ContainerKey) -> [Double]? {
        return self[raw: key]
    }
    
    public func decode(_ type: [String].Type, forKey key: Raw.ContainerKey) -> [String]? {
        return self[raw: key]
    }
    
    public func nestedContainer(forKey key: Raw.ContainerKey) -> RawContainerType? {
        guard case let .dictionary(value)? = contents[key] else {
            return nil
        }
        
        return Raw.Container(contents: value)
    }
    
    public func nestedContainers(forKey key: Raw.ContainerKey) -> [RawContainerType]? {
        guard case let .array(values)? = contents[key] else {
            return nil
        }
        
        return values.compactMap { rawValue in
            guard case let .dictionary(value) = rawValue else {
                return nil
            }
            
            return Raw.Container(contents: value)
        }
    }
}


extension Raw.Container: Sequence {
    public typealias Element = (key: Raw.ContainerKey, value: Any)
    
    public func makeIterator() -> AnyIterator<Element> {
        var iterator = contents.makeIterator()
        
        return AnyIterator {
            return iterator.next().map { Element(key: $0.key, value: $0.value.rawValue) }
        }
    }
}


extension Raw.Container: Collection {
    public typealias Index = Raw.ContainerIndex
    
    public var startIndex: Index {
        return Index(contents.startIndex)
    }
    
    public var endIndex: Index {
        return Index(contents.endIndex)
    }
    
    public func index(after i: Index) -> Index {
        return Index(contents.index(after: i.base))
    }
    
    public subscript(position: Index) -> Element {
        let element = contents[position.base]
        return (element.key, element.value.rawValue)
    }
}


public extension Raw {
    
    public struct ContainerIndex: Comparable {
        fileprivate typealias BaseIndex = Dictionary<ContainerKey,ContainerValue>.Index
        
        public static func < (lhs: Raw.ContainerIndex, rhs: Raw.ContainerIndex) -> Bool {
            return lhs.base < rhs.base
        }
        
        fileprivate let base: BaseIndex
        
        fileprivate init(_ base: BaseIndex) {
            self.base = base
        }
    }
}


private protocol RawContainerValue {}

extension Bool: RawContainerValue {}
extension Int: RawContainerValue {}
extension Double: RawContainerValue {}
extension String: RawContainerValue {}

private extension Raw.Container {
    subscript<T>(raw key: Raw.ContainerKey) -> [T]? where T : RawContainerValue {
        guard case let .array(value)? = contents[key] else {
            return nil
        }
        
        return value.compactMap({ $0.rawValue as? T })
    }
    
    subscript<T>(raw key: Raw.ContainerKey) -> T? where T : RawContainerValue {
        guard let containerValue = contents[key] else {
            return nil
        }
        
        switch containerValue {
        case .bool(let value as T):
            return value
        case .int(let value as T):
            return value
        case .double(let value as T):
            return value
        case .string(let value as T):
            return value
            
        default:
            return nil
        }
    }
}




private extension Raw {
    
    /// A private value type representing additional values included in raw objects.
    enum ContainerValue: Equatable {
        case bool(Bool)
        case int(Int)
        case double(Double)
        case string(String)
        indirect case array([Raw.ContainerValue])
        indirect case dictionary([Raw.ContainerKey: Raw.ContainerValue])
    }
}


extension Raw.ContainerValue: RawRepresentable {
    typealias RawValue = Any
    
    init?(rawValue: Any) {
        switch rawValue {
        case let value as Bool:
            self = .bool(value)
        case let value as Int:
            self = .int(value)
        case let value as Double:
            self = .double(value)
        case let value as String:
            self = .string(value)
        case let value as [Any]:
            self = .array(value.compactMap({ Raw.ContainerValue(rawValue: $0) }))
        case let value as [String: Any]:
            self = .dictionary(value.asContainerContents())
            
        default:
            return nil
        }
    }
    
    var rawValue: Any {
        switch self {
        case .bool(let value):
            return value
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .string(let value):
            return value
        case .array(let value):
            return value
        case .dictionary(let value):
            return value
        }
    }
}


extension Raw.ContainerValue: Codable {
    public init(from decoder: Decoder) throws {
        var result: Raw.ContainerValue?
        
        if let container = try? decoder.container(keyedBy: Raw.ContainerKey.self) {
            result = try .dictionary(container.decode([Raw.ContainerKey : Raw.ContainerValue].self))
            
        } else if var container = try? decoder.unkeyedContainer() {
            result = try .array(container.decode([Raw.ContainerValue].self))
            
        } else if let container = try? decoder.singleValueContainer() {
            result = try container.decode(Raw.ContainerValue.self)
        }
        
        guard let this = result else {
            throw DecodingError.typeNotSupported(codingPath: decoder.codingPath)
        }
        
        self = this
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case .bool(let value):
            try encoder.encode(singleValue: value)
        case .int(let value):
            try encoder.encode(singleValue: value)
        case .double(let value):
            try encoder.encode(singleValue: value)
        case .string(let value):
            try encoder.encode(singleValue: value)
            
        case .array(let value):
            var container = encoder.unkeyedContainer()
            try container.encode(value)
            
        case .dictionary(let value):
            var container = encoder.container(keyedBy: Raw.ContainerKey.self)
            try container.encode(value)
        }
    }
}


// MARK: - Decoding

private extension KeyedDecodingContainer where K == Raw.ContainerKey {
    func decode(_ type: [K: Raw.ContainerValue].Type, filter isIncluded: (K) -> Bool) throws -> [K: Raw.ContainerValue] {
        return try allKeys.filter(isIncluded).reduce(into: [K: Raw.ContainerValue]()) { result, key in
            result[key] = try decode(Raw.ContainerValue.self, forKey: key)
        }
    }
    
    func decode(_ type: [K: Raw.ContainerValue].Type) throws -> [K: Raw.ContainerValue] {
        return try decode(type, filter: { _ in true })
    }
}


private extension UnkeyedDecodingContainer {
    mutating func decode(_ type: [Raw.ContainerValue].Type) throws -> [Raw.ContainerValue] {
        var result: [Raw.ContainerValue] = []
        
        while !isAtEnd {
            result.append(try decode(Raw.ContainerValue.self))
        }
        
        return result
    }
}


private extension SingleValueDecodingContainer {
    func decode(_ type: Raw.ContainerValue.Type) throws -> Raw.ContainerValue? {
        if let value = try decode(possible: Bool.self) {
            return .bool(value)
            
        } else if let value = try decode(possible: Int.self) {
            return .int(value)
            
        } else if let value = try decode(possible: Double.self) {
            return .double(value)
            
        } else if let value = try decode(possible: String.self) {
            return .string(value)
            
        } else {
            return nil
        }
    }
    
    private func decode<T>(possible type: T.Type) throws -> T? where T : Decodable {
        var value: T?
        
        do {
            value = try decode(T.self)
        } catch let error as DecodingError {
            guard case .typeMismatch = error else {
                throw error
            }
            
        } catch {
            throw error
        }
        
        return value
    }
}


private extension DecodingError {
    static func typeNotSupported(codingPath: [CodingKey]) -> DecodingError {
        return DecodingError.dataCorrupted(Context(codingPath: codingPath, debugDescription: "value cannot be represented by Raw.ContainerValue"))
    }
}


// MARK: - Encoding

private extension Encoder {
    func encode<T: Encodable>(singleValue value: T) throws {
        var container = singleValueContainer()
        try container.encode(value)
    }
}


private extension KeyedEncodingContainer where K == Raw.ContainerKey {
    mutating func encode(_ value: [K: Raw.ContainerValue]) throws {
        for (k, v) in value {
            try encode(v, forKey: k)
        }
    }
}


private extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Raw.ContainerValue]) throws {
        for v in value {
            try encode(v)
        }
    }
}



extension Dictionary where Key == String, Value == Any {
    fileprivate func asContainerContents() -> Raw.Container.Contents {
        return reduce(into: Raw.Container.Contents()) { result, element in
            if let value = Raw.ContainerValue(rawValue: element.value) {
                result[Raw.ContainerKey(value: element.key)] = value
            }
        }
    }
}

