//
//  Link.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Link: Hashable {
    public var link: URL
    public var text: String
    public var title: String?
    public var description: String?
    public var range: Content.Range
    public var amendedRange: Content.Range?
    
    public init(link: URL, text: String, title: String? = nil, description: String? = nil, range: Content.Range, amendedRange: Content.Range? = nil) {
        self.link = link
        self.text = text
        self.title = title
        self.description = description
        self.range = range
        self.amendedRange = amendedRange
    }
    
    public init(link: URL, text: String, title: String? = nil, description: String? = nil, range: Content.Range, amendedLength: Int) {
        let amendedRange = Link.amendedRange(for: range, amendedLength: amendedLength)
        self.init(link: link, text: text, title: title, description: description, range: range, amendedRange: amendedRange)
    }
}


extension Link: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Link {
        var result = self
        result.range.adjust(for: pairs)
        result.amendedRange?.adjust(for: pairs)
        
        return result
    }
}


extension Link: Codable {
    private enum CodingKeys: String, CodingKey {
        case link
        case text
        case title
        case description
        case range
        case amendedRange
        case amendedLen = "amended_len"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decode(URL.self, forKey: .link)
        text = try container.decode(String.self, forKey: .text)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        if decoder.context?.source == .remote {
            range = try Content.Range(from: decoder)
            amendedRange = try container.decodeIfPresent(Int.self, forKey: .amendedLen).flatMap { amendedLen in
                return Link.amendedRange(for: range, amendedLength: amendedLen)
                //                return amendedLen > 0 ? Content.Range(position: range.max, length: range.position + amendedLen - range.max) : nil
            }
            
        } else {
            range = try container.decode(Content.Range.self, forKey: .range)
            amendedRange = try container.decodeIfPresent(Content.Range.self, forKey: .amendedRange)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(link, forKey: .link)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(description, forKey: .description)
        
        if encoder.context?.destination == .remote {
            try range.encode(to: encoder)
            try container.encodeIfPresent(amendedRange.flatMap({ range.length + $0.length }), forKey: .amendedLen)
            
        } else {
            try container.encode(range, forKey: .range)
            try container.encodeIfPresent(amendedRange, forKey: .amendedRange)
        }
    }
}


private extension Link {
    static func amendedRange(for range: Content.Range, amendedLength: Int) -> Content.Range? {
        return amendedLength > 0 ? Content.Range(position: range.max, length: range.position + amendedLength - range.max) : nil
    }
}
