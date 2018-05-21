//
//  User.Counts.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User {
    
    public struct Counts: Hashable, Codable {
        public var bookmarks: Int
        public var clients: Int
        public var followers: Int
        public var following: Int
        public var posts: Int
        public var users: Int
        
        public init(bookmarks: Int, clients: Int, followers: Int, following: Int, posts: Int, users: Int) {
            self.bookmarks = bookmarks
            self.clients = clients
            self.followers = followers
            self.following = following
            self.posts = posts
            self.users = users
        }
    }
}
