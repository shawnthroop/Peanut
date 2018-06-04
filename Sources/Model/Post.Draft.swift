//
//  Post.Draft.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post {
    
    public struct Draft: Equatable {
        public var text: String
        public var replyTo: Post.ID?
        public var isNSFW: Bool
        public var parseLinks: Bool
        public var parseMarkdownLinks: Bool
        public var raw: [Raw] = []
        
        public init(text: String, replyTo: Post.ID? = nil, isNSFW: Bool = false, parseLinks: Bool = true, parseMarkdownLinks: Bool = true, raw: [Raw] = []) {
            self.text = text
            self.replyTo = replyTo
            self.isNSFW = isNSFW
            self.parseLinks = parseLinks
            self.parseMarkdownLinks = parseMarkdownLinks
            self.raw = raw
        }
    }
}


extension Post.Draft: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encodeIfPresent(replyTo, forKey: .replyTo)
        try container.encode(isNSFW, forKey: .isNSFW, where: { $0 == true })
        try container.encode(parseLinks, forKey: .parseLinks, where: { $0 == false })
        try container.encode(parseMarkdownLinks, forKey: .parseMarkdownLinks, where: { $0 == false })
        try container.encode(raw, forKey: .raw, where: { $0.isEmpty == false })
    }
}


private extension Post.Draft {
    enum CodingKeys: String, CodingKey {
        case text
        case replyTo            = "reply_to"
        case isNSFW             = "is_nsfw"
        case parseLinks         = "entities.parse_links"
        case parseMarkdownLinks = "entities.parse_markdown_links"
        case raw
    }
}
