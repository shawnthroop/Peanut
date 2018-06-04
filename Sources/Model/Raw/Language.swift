//
//  Language.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Language: Equatable {
    public var locale: Locale
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(locale: Locale, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.locale = locale
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Raw {
    public static let language: Identifier = "io.pnut.core.language"
}


extension Language: RawContentValueType {
    public static let validDecodableKeys: RawContentKeyDecodable.Keys = [.locale]
}


extension Language: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
        unvalidatedContent = try container.decodeUnvalidatedContent(for: Language.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(locale.identifier, forKey: .locale)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension Identifier where T == RawContent {
    static let locale: Identifier = "language"
}







//private extension Identifier where T == Raw.Value {
//    static let locale: Identifier = "language"
//}


//extension Raw {
//    public var language: Language? {
//        if case let .language(v) = value {
//            return v
//        }
//        
//        return nil
//    }
//}
//
//
//extension Language: RawValueType {
//    public static let supportedKeys: Raw.ContainerKeys = [.locale]
//}
//
//
//extension Language: RawCodable, Codable {
//    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
//        locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Raw.ContainerKey.self)
//        locale = try Locale(identifier: container.decode(String.self, forKey: .locale))
//    }
//
//    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
//        try container.encode(locale.identifier, forKey: .locale)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Raw.ContainerKey.self)
//        try container.encode(locale.identifier, forKey: .locale)
//    }
//}
//
//
//private extension Identifier where T == Raw.Value {
//    static let locale: Identifier = "language"
//}
