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
        
        public init(url: URL, expiresAt: Date) {
            self.url = url
            self.expiresAt = expiresAt
        }
    }
}


private extension File.Link {
    enum CodingKeys: String, CodingKey {
        case url        = "link"
        case expiresAt  = "link_expires_at"
    }
}
