//
//  OembedPhoto.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct OembedPhoto: Hashable {
    public var version: String
    public var width: Int
    public var height: Int
    public var url: URL
    public var authorName: String?
    public var authorURL: URL?
    public var providerName: String?
    public var providerURL: URL?
    public var embeddableURL: URL?
    public var thumbnail: OembedThumbnail?
}


extension OembedPhoto: OembedValueType {
    public static let supportedKeys: Raw.ContainerKeys = makeSupportedKeys()
    public static let oembedType: String = "photo"
    
    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
        guard try container.decode(String.self, forKey: .type) == OembedPhoto.oembedType else {
            return nil
        }
        
        version = try container.decode(String.self, forKey: .version)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        url = try container.decode(URL.self, forKey: .url)
        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        authorURL = try container.decodeIfPresent(URL.self, forKey: .authorURL)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
        thumbnail = try OembedThumbnail(from: container)
    }
    
    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try container.encode(version, forKey: .version)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(authorName, forKey: .authorName)
        try container.encodeIfPresent(authorURL, forKey: .authorURL)
        try container.encodeIfPresent(providerName, forKey: .providerName)
        try container.encodeIfPresent(providerURL, forKey: .providerURL)
        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
        
        if let thumbnail = thumbnail {
            try thumbnail.encode(to: &container)
        }
    }
}


private extension OembedPhoto {
    static func makeSupportedKeys() -> Raw.ContainerKeys {
        var result = Raw.ContainerKeys()
        result.insert(.width)
        result.insert(.height)
        result.insert(.url)
        result.insert(.authorName)
        result.insert(.authorURL)
        result.insert(.providerName)
        result.insert(.providerURL)
        result.insert(.embeddableURL)
        
        return Oembed.requiredKeys.union(OembedThumbnail.supportedKeys).union(result)
    }
}
