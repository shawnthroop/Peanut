//
//  OembedPhoto.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct OembedPhoto: Equatable {
    public var version: String
    public var width: Int
    public var height: Int
    public var url: URL
    public var authorName: String?
    public var authorURL: URL?
    public var providerName: String?
    public var providerURL: URL?
    public var embeddableURL: URL?
    public var thumbnail: Oembed.Thumbnail?
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(version: String = "1.0", width: Int, height: Int, url: URL, authorName: String?, authorURL: URL?, providerName: String?, providerURL: URL?, embeddableURL: URL?, thumbnail: Oembed.Thumbnail?, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.version = version
        self.width = width
        self.height = height
        self.url = url
        self.authorName = authorName
        self.authorURL = authorURL
        self.providerName = providerName
        self.providerURL = providerURL
        self.embeddableURL = embeddableURL
        self.thumbnail = thumbnail
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Oembed {
    public static let photo: Identifier = "photo"
}


extension OembedPhoto: OembedValueType {
    public static let type: Identifier<Oembed> = .photo
}


extension OembedPhoto: RawContentValueType {
    public static let validDecodableKeys: Keys = makeValidDecodableKeys()
}


extension OembedPhoto: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        try container.ensureType(matches: OembedPhoto.self)
        version = try container.decode(String.self, forKey: .version)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        url = try container.decode(URL.self, forKey: .url)
        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        authorURL = try container.decodeIfPresent(URL.self, forKey: .authorURL)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
        thumbnail = try Oembed.Thumbnail(fromUnvalidated: decoder)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: OembedPhoto.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encodeType(OembedPhoto.self)
        try container.encode(version, forKey: .version)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(authorName, forKey: .authorName)
        try container.encodeIfPresent(authorURL, forKey: .authorURL)
        try container.encodeIfPresent(providerName, forKey: .providerName)
        try container.encodeIfPresent(providerURL, forKey: .providerURL)
        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
        try thumbnail?.encode(to: encoder)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension OembedPhoto {
    static func makeValidDecodableKeys() -> Keys {
        var result = Keys()
        result.insert(.type)
        result.insert(.version)
        result.insert(.width)
        result.insert(.height)
        result.insert(.url)
        result.insert(.authorName)
        result.insert(.authorURL)
        result.insert(.providerName)
        result.insert(.providerURL)
        result.insert(.embeddableURL)

        return result.union(Oembed.Thumbnail.validDecodableKeys)
    }
}


//public struct OembedPhoto: Hashable {
//    public var version: String
//    public var width: Int
//    public var height: Int
//    public var url: URL
//    public var authorName: String?
//    public var authorURL: URL?
//    public var providerName: String?
//    public var providerURL: URL?
//    public var embeddableURL: URL?
//    public var thumbnail: Oembed.Thumbnail?
//}
//
//
//extension OembedPhoto: OembedValueType, Codable {
//    public static let supportedKeys: Raw.ContainerKeys = makeSupportedKeys()
//    public static let oembedType: String = "photo"
//    
//    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
//        guard try container.decode(String.self, forKey: .type) == OembedPhoto.oembedType else {
//            return nil
//        }
//        
//        version = try container.decode(String.self, forKey: .version)
//        width = try container.decode(Int.self, forKey: .width)
//        height = try container.decode(Int.self, forKey: .height)
//        url = try container.decode(URL.self, forKey: .url)
//        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
//        authorURL = try container.decodeIfPresent(URL.self, forKey: .authorURL)
//        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
//        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
//        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
//        thumbnail = try Oembed.Thumbnail(from: container)
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Raw.ContainerKey.self)
//        let type = try container.decode(String.self, forKey: .type)
//
//        guard type == OembedPhoto.oembedType else {
//            throw Raw.DecodingError.oembedTypeMismatch(type: OembedPhoto.self, foundType: type)
//        }
//        
//        version = try container.decode(String.self, forKey: .version)
//        width = try container.decode(Int.self, forKey: .width)
//        height = try container.decode(Int.self, forKey: .height)
//        url = try container.decode(URL.self, forKey: .url)
//        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
//        authorURL = try container.decodeIfPresent(URL.self, forKey: .authorURL)
//        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
//        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
//        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
//        thumbnail = try Oembed.Thumbnail(optionalFrom: decoder)
//    }
//    
//    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
//        try container.encode(version, forKey: .version)
//        try container.encode(width, forKey: .width)
//        try container.encode(height, forKey: .height)
//        try container.encode(url, forKey: .url)
//        try container.encodeIfPresent(authorName, forKey: .authorName)
//        try container.encodeIfPresent(authorURL, forKey: .authorURL)
//        try container.encodeIfPresent(providerName, forKey: .providerName)
//        try container.encodeIfPresent(providerURL, forKey: .providerURL)
//        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
//
//        if let thumbnail = thumbnail {
//            try thumbnail.encode(to: &container)
//        }
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Raw.ContainerKey.self)
//        
//        try container.encode(version, forKey: .version)
//        try container.encode(width, forKey: .width)
//        try container.encode(height, forKey: .height)
//        try container.encode(url, forKey: .url)
//        try container.encodeIfPresent(authorName, forKey: .authorName)
//        try container.encodeIfPresent(authorURL, forKey: .authorURL)
//        try container.encodeIfPresent(providerName, forKey: .providerName)
//        try container.encodeIfPresent(providerURL, forKey: .providerURL)
//        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
//        try thumbnail?.encode(to: encoder)
//    }
//}
//
//
//private extension OembedPhoto {
//    static func makeSupportedKeys() -> Raw.ContainerKeys {
//        var result = Oembed.requiredKeys
//        result.insert(.width)
//        result.insert(.height)
//        result.insert(.url)
//        result.insert(.authorName)
//        result.insert(.authorURL)
//        result.insert(.providerName)
//        result.insert(.providerURL)
//        result.insert(.embeddableURL)
//        
//        return result.union(Oembed.Thumbnail.supportedKeys)
//    }
//}
