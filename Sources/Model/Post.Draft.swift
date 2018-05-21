//
//  Post.Draft.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post {
    
    public struct Draft: Hashable {
        public var text: String
        public var replyTo: Post.ID?
        public var isNSFW: Bool
        public var parseLinks: Bool
        public var parseMarkdownLinks: Bool
        
        public init(text: String, replyTo: Post.ID? = nil, isNSFW: Bool = false, parseLinks: Bool = true, parseMarkdownLinks: Bool = true) {
            self.text = text
            self.replyTo = replyTo
            self.isNSFW = isNSFW
            self.parseLinks = parseLinks
            self.parseMarkdownLinks = parseMarkdownLinks
        }
    }
}


extension Post.Draft: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(replyTo, forKey: .replyTo)
        
        if isNSFW {
            try container.encode(true, forKey: .isNSFW)
        }
        
        if !parseLinks {
            try container.encode(false, forKey: .parseLinks)
        }
        
        if !parseMarkdownLinks {
            try container.encode(false, forKey: .parseMarkdownLinks)
        }
    }
}


private extension Post.Draft {
    enum CodingKeys: String, CodingKey {
        case text
        case replyTo            = "reply_to"
        case isNSFW             = "is_nsfw"
        case parseLinks         = "entities.parse_links"
        case parseMarkdownLinks = "entities.parse_markdown_links"
    }
}
