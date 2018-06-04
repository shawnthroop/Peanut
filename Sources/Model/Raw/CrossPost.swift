//
//  CrossPost.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct CrossPost: Equatable {
    public var canonicalURL: URL
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(canonicalURL: URL, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.canonicalURL = canonicalURL
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Raw {
    public static let crossPost: Identifier = "io.pnut.core.crosspost"
}


extension CrossPost: RawContentValueType {
    public static let validDecodableKeys: Keys = [.canonicalURL]
}


extension CrossPost: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        canonicalURL = try container.decode(URL.self, forKey: .canonicalURL)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: CrossPost.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(canonicalURL, forKey: .canonicalURL)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension Identifier where T == RawContent {
    static let canonicalURL: Identifier = "canonical_url"
}

//extension Raw {
//    public var crossPost: CrossPost? {
//        if case let .crossPost(v) = value {
//            return v
//        }
//        
//        return nil
//    }
//}
//
//
//extension CrossPost: RawValueType {
//    public static let supportedKeys: Raw.ContainerKeys = [.canonicalURL]
//}
//
//
//extension CrossPost: RawCodable, Codable {
//    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
//        canonicalURL = try container.decode(URL.self, forKey: .canonicalURL)
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Raw.ContainerKey.self)
//        canonicalURL = try container.decode(URL.self, forKey: .canonicalURL)
//    }
//
//    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
//        try container.encode(canonicalURL, forKey: .canonicalURL)
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Raw.ContainerKey.self)
//        try container.encode(canonicalURL, forKey: .canonicalURL)
//    }
//}
//
//
