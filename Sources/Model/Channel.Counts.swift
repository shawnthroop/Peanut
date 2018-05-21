//
//  Channel.Counts.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension Channel {
    
    public struct Counts: Hashable, Encodable {
        public var messages: Int
        public var subscribers: Int
    }
}


extension Channel.Counts: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        messages = try container.decode(Int.self, forKey: .messages)
        subscribers = try container.decodeIfPresent(Int.self, forKey: .subscribers) ?? 0
    }
}


private extension Channel.Counts {
    enum CodingKeys: String, CodingKey {
        case messages
        case subscribers
    }
}
