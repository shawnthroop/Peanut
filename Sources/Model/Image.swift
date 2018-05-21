//
//  Image.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Image: Hashable, Codable {
    public var link: URL
    public var width: Int
    public var height: Int
    public var isDefault: Bool
    
    public init(link: URL, width: Int, height: Int, isDefault: Bool = false) {
        self.link = link
        self.width = width
        self.height = height
        self.isDefault = isDefault
    }
}


private extension Image {
    enum CodingKeys: String, CodingKey {
        case link
        case width
        case height
        case isDefault  = "is_default"
    }
}
