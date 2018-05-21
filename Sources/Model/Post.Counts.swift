//
//  Post.Counts.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post {
    
    public struct Counts: Hashable, Codable {
        var bookmarks: Int
        var replies: Int
        var reposts: Int
        var threads: Int
    }
}
