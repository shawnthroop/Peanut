//
//  APIMeta.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIMeta: Hashable {
    public var code: APIStatusCode
    public var more: Bool
    public var max: UniqueIdentifier?
    public var min: UniqueIdentifier?
    public var marker: APIMarker?
}


extension APIMeta: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(APIStatusCode.self, forKey: .code)
        more = try container.decodeIfPresent(Bool.self, forKey: .more) ?? false
        max = try container.decodeIfPresent(UniqueIdentifier.self, forKey: .max)
        min = try container.decodeIfPresent(UniqueIdentifier.self, forKey: .min)
        marker = try container.decodeIfPresent(APIMarker.self, forKey: .marker)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encodeIfPresent(max, forKey: .max)
        try container.encodeIfPresent(min, forKey: .min)
        try container.encodeIfPresent(marker, forKey: .marker)
        
        if more {
            try container.encode(true, forKey: .more)
        }
    }
}


private extension APIMeta {
    enum CodingKeys: String, CodingKey {
        case code
        case more
        case max = "max_id"
        case min = "min_id"
        case marker
    }
}

