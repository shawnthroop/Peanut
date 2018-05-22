//
//  File.Link.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

extension File {
    
    public struct Link: Hashable, Codable {
        public var url: URL
        public var expiresAt: Date
        public var shortURL: URL?
        
        public init(url: URL, expiresAt: Date, shortURL: URL?) {
            self.url = url
            self.expiresAt = expiresAt
            self.shortURL = shortURL
        }
    }
}


private extension File.Link {
    enum CodingKeys: String, CodingKey {
        case url        = "link"
        case expiresAt  = "link_expires_at"
        case shortURL   = "link_short"
    }
}
