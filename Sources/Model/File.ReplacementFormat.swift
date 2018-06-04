//
//  File.ReplacementFormat.swift
//  Peanut
//
//  Created by Shawn Throop on 26.05.18.
//

extension File {
    
    public enum ReplacementFormat: String, Hashable, Codable {
        case url
        case metadata
        case oembed
    }
}
