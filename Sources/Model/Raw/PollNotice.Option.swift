//
//  PollNotice.Option.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

extension PollNotice {
    
    public struct Option: Hashable, Codable {
        public var text: String
        public var position: Int
    }
}
