//
//  User.Verification.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User {
    
    public struct Verification: Hashable, Codable {
        public var domain: String
        public var link: URL
        
        public init(domain: String, link: URL) {
            self.domain = domain
            self.link = link
        }
    }
}
