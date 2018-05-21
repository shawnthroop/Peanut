//
//  Language.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Language: Equatable {
    public let locale: Locale
}


extension Identifier where T == Raw {
    public static let language: Identifier = "io.pnut.core.language"
}


extension Raw {
    public var language: Language? {
        if case let .language(v) = value {
            return v
        }
        
        return nil
    }
}


extension Language: RawValueType {
    public static let supportedKeys: Raw.ContainerKeys = [.locale]
    
    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
        locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
    }
    
    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try container.encode(locale.identifier, forKey: .locale)
    }
}


private extension Identifier where T == Raw.Value {
    static let locale: Identifier = "language"
}
