//
//  Identifier.swift
//  Peanut iOS
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Identifier<T: Identifiable>: Hashable {
    public let value: T.IdentifierValue
    
    public init(value: T.IdentifierValue) {
        self.value = value
    }
}


extension Identifier: Codable where T.IdentifierValue: Codable {
    public init(from decoder: Decoder) throws {
        try self.init(value: decoder.singleValueContainer().decode(T.IdentifierValue.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}


// MARK: - ExpressibleByIntegerLiteral

extension Identifier: ExpressibleByIntegerLiteral where T.IdentifierValue: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = T.IdentifierValue.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value: T.IdentifierValue(integerLiteral: value))
    }
}


// MARK: - ExpressibleByStringLiteral

extension Identifier: ExpressibleByUnicodeScalarLiteral where T.IdentifierValue == String {
    public typealias UnicodeScalarLiteralType = UnicodeScalar
    
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self.init(value: String(value))
    }
}


extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral where T.IdentifierValue == String {
    public typealias ExtendedGraphemeClusterLiteralType = Character
    
    public init(extendedGraphemeClusterLiteral value: Character) {
        self.init(value: String(value))
    }
}


extension Identifier: ExpressibleByStringLiteral where T.IdentifierValue == String {
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(value: value)
    }
}


// MARK: - APIParameterValue

extension Identifier: APIParameterValue where T.IdentifierValue: APIParameterValue {
    public var parameterValue: String {
        return value.parameterValue
    }
}


// MARK: AnyDictionaryKey

extension Identifier: AnyDictionaryKey where T.IdentifierValue == String {
    public init(keyValue: String) {
        self.init(value: keyValue)
    }
    
    public var keyValue: String {
        return value
    }
}


// MARK: - CodingKey

extension Identifier: CodingKey where T.IdentifierValue == String {
    public init?(intValue: Int) {
        self.init(value: String(intValue))
    }
    
    public init?(stringValue: String) {
        self.init(value: stringValue)
    }
    
    public var stringValue: String {
        return value
    }
    
    public var intValue: Int? {
        return Int(value)
    }
}


extension Identifier: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}


extension Identifier: CustomDebugStringConvertible {
    public var debugDescription: String {
        guard let value = value as? CustomDebugStringConvertible else {
            return description
        }
        
        return value.debugDescription
    }
}
