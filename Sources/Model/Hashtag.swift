//
//  Hashtag.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Hashtag: Hashable {
    public var text: String
    public var range: Content.Range
    
    public init(text: String, range: Content.Range) {
        self.text = text
        self.range = range
    }
}


extension Hashtag {
    var formatted: String {
        return "#" + text
    }
}


extension Hashtag: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Hashtag {
        var result = self
        result.range.adjust(for: pairs)
        
        return result
    }
}


extension Hashtag: Codable {
    private enum CodingKeys: String, CodingKey {
        case text
        case range
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        
        if decoder.context?.source == .remote {
            range = try Content.Range(from: decoder)
        } else {
            range = try container.decode(Content.Range.self, forKey: .range)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        
        if encoder.context?.destination == .remote {
            try range.encode(to: encoder)
        } else {
            try container.encode(range, forKey: .range)
        }
    }
}
