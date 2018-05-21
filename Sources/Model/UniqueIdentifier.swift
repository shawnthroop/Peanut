//
//  UniqueIdentifier.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// A value representing a unique identifier of an object. For example a User `id`.
public struct UniqueIdentifier: Hashable, Codable {
    public let uniqueValue: Int
    
    public init(uniqueValue: Int) {
        self.uniqueValue = uniqueValue
    }
}


extension Identifier where T.IdentifierValue == UniqueIdentifier {
    public var rawValue: String {
        return value.rawValue
    }
    
    public var uniqueValue: Int {
        return value.uniqueValue
    }
}


extension UniqueIdentifier: RawRepresentable {
    public init?(rawValue: String) {
        guard let value = Int(rawValue) else {
            return nil
        }
        
        self.init(uniqueValue: value)
    }
    
    public var rawValue: String {
        return String(uniqueValue)
    }
}


extension UniqueIdentifier: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(uniqueValue: value)
    }
}


extension UniqueIdentifier: APIParameterValue {
    public var parameterValue: String {
        return rawValue
    }
}
