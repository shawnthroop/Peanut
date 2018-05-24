//
//  File.AudioInformation.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File {
    
    public struct AudioInformation: Hashable, Codable {
        public var duration: Int
        public var bitrate: Int
        
        public init(duration: Int, bitrate: Int) {
            self.duration = duration
            self.bitrate = bitrate
        }
    }
}
