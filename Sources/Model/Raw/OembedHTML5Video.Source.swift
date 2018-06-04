//
//  OembedHTML5Video.Source.swift
//  Peanut
//
//  Created by Shawn Throop on 02.06.18.
//

extension OembedHTML5Video {
    
    public struct Source: Hashable, Codable {
        public var type: String
        public var url: URL
        
        public init(type: String, url: URL) {
            self.type = type
            self.url = url
        }
    }
}


private extension OembedHTML5Video.Source {
    enum CodingKeys: CodingKey {
        case type
        case url
    }
}
