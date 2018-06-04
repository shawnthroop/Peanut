//
//  OembedHTML5Video.swift
//  Peanut
//
//  Created by Shawn Throop on 02.06.18.
//

public struct OembedHTML5Video: Equatable {
    public var version: String
    public var width: Int
    public var height: Int
    public var sources: [Source]
    public var title: String?
    public var authorName: String?
    public var authorURL: URL?
    public var providerName: String?
    public var providerURL: URL?
    public var posterURL: URL?
    public var embeddableURL: URL?
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(version: String = "1.0", width: Int, height: Int, sources: [Source], title: String?, authorName: String?, authorURL: URL?, providerName: String?, providerURL: URL?, posterURL: URL?, embeddableURL: URL?, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.version = version
        self.width = width
        self.height = height
        self.sources = sources
        self.title = title
        self.authorName = authorName
        self.authorURL = authorURL
        self.providerName = providerName
        self.providerURL = providerURL
        self.posterURL = posterURL
        self.embeddableURL = embeddableURL
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Oembed {
    static let html5Video: Identifier = "html5video"
}


extension Identifier where T == RawContent {
    static let sources: Identifier = "sources"
}


extension OembedHTML5Video: OembedValueType {
    public static let type: Identifier<Oembed> = .html5Video
}


extension OembedHTML5Video: RawContentValueType {
    public static var validDecodableKeys: Keys = makeValidDecodableKeys()
}


extension OembedHTML5Video: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        try container.ensureType(matches: OembedHTML5Video.self)
        version = try container.decode(String.self, forKey: .version)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        sources = try container.decode([Source].self, forKey: .sources)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        authorName = try container.decodeIfPresent(String.self, forKey: .authorName)
        authorURL = try container.decodeIfPresent(URL.self, forKey: .authorURL)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
        posterURL = try container.decodeIfPresent(URL.self, forKey: .posterURL)
        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: OembedHTML5Video.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encodeType(OembedHTML5Video.self)
        try container.encode(version, forKey: .version)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(sources, forKey: .sources)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(authorName, forKey: .authorName)
        try container.encodeIfPresent(authorURL, forKey: .authorURL)
        try container.encodeIfPresent(providerName, forKey: .providerName)
        try container.encodeIfPresent(providerURL, forKey: .providerURL)
        try container.encodeIfPresent(posterURL, forKey: .posterURL)
        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension OembedHTML5Video {
    static func makeValidDecodableKeys() -> Keys {
        var result = Keys()
        result.insert(.version)
        result.insert(.type)
        result.insert(.width)
        result.insert(.height)
        result.insert(.sources)
        result.insert(.title)
        result.insert(.authorName)
        result.insert(.authorURL)
        result.insert(.providerName)
        result.insert(.providerURL)
        result.insert(.posterURL)
        result.insert(.embeddableURL)
        
        return result
    }
}
