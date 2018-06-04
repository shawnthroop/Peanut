//
//  AnyDictionary.EncodableValue.swift
//  Peanut
//
//  Created by Shawn Throop on 30.05.18.
//

extension AnyDictionary {
    
    public struct EncodableValue {
        var base: Any {
            return value.base
        }
        
        private let value: AnyEquatable
        private let encodeValue: (Encoder, AnyEquatable) throws -> Void
        
        public init<E>(_ base: E) where E : Encodable & Equatable {
            self.value = AnyEquatable(base)
            self.encodeValue = { try EncodableValue.encode($1, as: E.self, to: $0) }
        }
    }
}


extension AnyDictionary.EncodableValue: Equatable {
    public static func == (lhs: AnyDictionary<Key>.EncodableValue, rhs: AnyDictionary<Key>.EncodableValue) -> Bool {
        return lhs.value == rhs.value
    }
}


extension AnyDictionary.EncodableValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        try encodeValue(encoder, value)
    }
}


extension AnyDictionary.EncodableValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        func wrap<T: Encodable & Equatable>(_ value: T) -> AnyDictionary.EncodableValue {
            return AnyDictionary.EncodableValue(value)
        }
        
        var result: AnyDictionary.EncodableValue?
        
        if let value = try container.decode(possible: Bool.self) {
            result = wrap(value)
            
        } else if let value = try container.decode(possible: Float.self) {
            result = wrap(value)
            
        } else if let value = try container.decode(possible: Int.self) {
            result = wrap(value)
            
        } else if let value = try container.decode(possible: String.self) {
            result = wrap(value)
            
        } else if let value = try container.decode(possible: [String: AnyDictionary.EncodableValue].self) {
            result = wrap(value)
            
        } else if let value = try container.decode(possible: [AnyDictionary.EncodableValue].self) {
            result = wrap(value)
        }
        
        guard let this = result else {
            throw DecodingError.typeUnsupported(AnyDictionary.EncodableValue.self, codingPath: decoder.codingPath)
        }
        
        self = this
    }
}


extension AnyDictionary.EncodableValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}


extension AnyDictionary.EncodableValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self.init(value)
    }
}


extension AnyDictionary.EncodableValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}


extension AnyDictionary.EncodableValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}


extension AnyDictionary.EncodableValue: CustomStringConvertible {
    public var description: String {
        return String(describing: base)
    }
}


private extension SingleValueDecodingContainer {
    func decode<T: Decodable>(possible type: T.Type) throws -> T? {
        var result: T?
        
        do {
            result = try decode(type)
            
        } catch {
            guard let err = error as? DecodingError, case .typeMismatch = err else {
                throw error
            }
        }
        
        return result
    }
}

private extension AnyDictionary.EncodableValue {
    static func encode<T: Encodable>(_ value: AnyEquatable, as type: T.Type, to encoder: Encoder) throws {
        guard let base = value.base as? T else {
            fatalError("Base value should always conform to Encodable")
        }
        
        var container = encoder.singleValueContainer()
        try container.encode(base)
    }
}


private extension DecodingError {
    static func typeUnsupported<Key>(_ type: AnyDictionary<Key>.EncodableValue.Type, codingPath path: [CodingKey]) -> DecodingError {
        return .typeMismatch(type, Context(codingPath: path, debugDescription: "Unable to decode a supported Encodable value"))
    }
}
