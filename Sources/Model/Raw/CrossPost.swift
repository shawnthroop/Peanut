//
//  CrossPost.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct CrossPost: Hashable {
    public var canonicalURL: URL
}


extension Identifier where T == Raw {
    static let crossPost: Identifier = "io.pnut.core.crosspost"
}


extension Raw {
    public var crossPost: CrossPost? {
        if case let .crossPost(v) = value {
            return v
        }
        
        return nil
    }
}


extension CrossPost: RawValueType {
    public static let supportedKeys: Raw.ContainerKeys = [.canonicalURL]
    
    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
        canonicalURL = try container.decode(URL.self, forKey: .canonicalURL)
    }
    
    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try container.encode(canonicalURL, forKey: .canonicalURL)
    }
}


private extension Identifier where T == Raw.Value {
    static let canonicalURL: Identifier = "canonical_url"
}
