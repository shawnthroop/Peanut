//
//  OembedSource.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct OembedSource: Hashable, Codable {
    public var type: String
    public var url: URL
    
    public init(type: String, url: URL) {
        self.type = type
        self.url = url
    }
}


extension Identifier where T == Raw.Value {
    public static let sources = Identifier(value: "sources")
}


extension Raw {
    public var sources: [OembedSource]? {
        return decode([OembedSource].self, forKey: .sources)
    }
}


extension OembedSource: RawContainerDecodable {
    public init?(from container: RawContainerType) {
        guard let type = container.decode(String.self, forKey: .type), let url = container.decode(URL.self, forKey: .url) else {
            return nil
        }
        
        self.type = type
        self.url = url
    }
}
