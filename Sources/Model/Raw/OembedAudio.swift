//
//  OembedAudio.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

public struct OembedAudio: Equatable {
    public var version: String
    public var duration: Int
    public var bitrate: Int?
    public var title: String?
    public var genre: String?
    public var providerName: String?
    public var providerURL: URL?
    public var embeddableURL: URL?
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(version: String = "1.0", duration: Int, bitrate: Int?, title: String?, genre: String?, providerName: String?, providerURL: URL?, embeddableURL: URL?, thumbnail: Oembed.Thumbnail?, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.version = version
        self.duration = duration
        self.bitrate = bitrate
        self.title = title
        self.genre = genre
        self.providerName = providerName
        self.providerURL = providerURL
        self.embeddableURL = embeddableURL
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Oembed {
    public static let audio: Identifier = "audio"
}


extension Identifier where T == RawContent {
    static let duration: Identifier = "duration"
    static let bitrate: Identifier = "bitrate"
    static let genre: Identifier = "genre"
}


extension OembedAudio: OembedValueType {
    public static var type: Identifier<Oembed> = .audio
}


extension OembedAudio: RawContentValueType {
    public static var validDecodableKeys: Keys = makeValidDecodableKeys()
}


extension OembedAudio: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        try container.ensureType(matches: OembedAudio.self)
        version = try container.decode(String.self, forKey: .version)
        duration = try container.decode(Int.self, forKey: .duration)
        bitrate = try container.decodeIfPresent(Int.self, forKey: .bitrate)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        genre = try container.decodeIfPresent(String.self, forKey: .genre)
        providerName = try container.decodeIfPresent(String.self, forKey: .providerName)
        providerURL = try container.decodeIfPresent(URL.self, forKey: .providerURL)
        embeddableURL = try container.decodeIfPresent(URL.self, forKey: .embeddableURL)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: OembedPhoto.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encodeType(OembedAudio.self)
        try container.encode(version, forKey: .version)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(bitrate, forKey: .bitrate)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(genre, forKey: .genre)
        try container.encodeIfPresent(providerName, forKey: .providerName)
        try container.encodeIfPresent(providerURL, forKey: .providerURL)
        try container.encodeIfPresent(embeddableURL, forKey: .embeddableURL)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension OembedAudio {
    static func makeValidDecodableKeys() -> Keys {
        var result = Keys()
        result.insert(.type)
        result.insert(.version)
        result.insert(.duration)
        result.insert(.bitrate)
        result.insert(.title)
        result.insert(.genre)
        result.insert(.providerName)
        result.insert(.providerURL)
        result.insert(.embeddableURL)
        
        return result
    }
}
