//
//  OembedThumbnail.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct OembedThumbnail: Hashable {
    public var url: URL
    public var width: Int
    public var height: Int
    
    public init(url: URL, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
}


public extension Identifier where T == Raw.Value {
    public static let thumbnailURL = Identifier(value: "thumbnail_url")
    public static let thumbnailWidth = Identifier(value: "thumbnail_width")
    public static let thumbnailHeight = Identifier(value: "thumbnail_height")
}


extension Raw {
    var thumbnail: OembedThumbnail? {
        return OembedThumbnail(from: self)
    }
}


extension OembedThumbnail: RawCodable {
    public static let supportedKeys: Raw.ContainerKeys = [.thumbnailURL, .thumbnailWidth, .thumbnailHeight]
    
    public init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws {
        guard container.contains(.thumbnailURL) else {
            return nil
        }
        
        url = try container.decode(URL.self, forKey: .thumbnailURL)
        width = try container.decode(Int.self, forKey: .thumbnailWidth)
        height = try container.decode(Int.self, forKey: .thumbnailHeight)
    }
    
    public func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws {
        try container.encode(url, forKey: .url)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
    }
}


extension OembedThumbnail: RawContainerDecodable {
    public init?(from container: RawContainerType) {
        guard
            let url = container.decode(URL.self, forKey: .thumbnailURL),
            let width = container.decode(Int.self, forKey: .thumbnailWidth),
            let height = container.decode(Int.self, forKey: .thumbnailHeight) else {
                return nil
        }
        
        self.init(url: url, width: width, height: height)
    }
}
