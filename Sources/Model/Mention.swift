//
//  Mention.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Mention: Hashable {
    public var id: User.ID
    public var username: String
    public var isLeading: Bool
    public var isCopy: Bool
    public var range: Content.Range
    
    public init(id: User.ID, username: String, isLeading: Bool = false, isCopy: Bool = false, range: Content.Range) {
        self.id = id
        self.username = username
        self.isLeading = isLeading
        self.isCopy = isCopy
        self.range = range
    }
}


extension Mention: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Mention {
        var result = self
        result.range.adjust(for: pairs)
        
        return result
    }
}


extension Mention: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case username   = "text"
        case isLeading  = "is_leading"
        case isCopy     = "is_copy"
        case range
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(User.ID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        isLeading = try container.decodeIfPresent(Bool.self, forKey: .isLeading) ?? false
        isCopy = try container.decodeIfPresent(Bool.self, forKey: .isCopy) ?? false
        
        if decoder.context?.source == .remote {
            range = try Content.Range(from: decoder)
        } else {
            range = try container.decode(Content.Range.self, forKey: .range)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(username, forKey: .username)
        
        if isLeading {
            try container.encode(isLeading, forKey: .isLeading)
        }
        
        if isCopy {
            try container.encode(isCopy, forKey: .isCopy)
        }
        
        if encoder.context?.destination == .remote {
            try range.encode(to: encoder)
        } else {
            try container.encode(range, forKey: .range)
        }
    }
}
