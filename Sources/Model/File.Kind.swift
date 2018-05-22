//
//  File.Kind.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

extension File {
    
    public enum Kind: String, Codable {
        case audio
        case image
        case other
    }
}
