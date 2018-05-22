//
//  Poll.Response.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll {
    
    public struct Response: Hashable {
        public var count: Int
        public var ids: Set<Poll.ID>
    }
}

