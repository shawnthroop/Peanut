//
//  File.ImageInformation.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File {
    
    public struct ImageInformation: Hashable, Codable {
        public var width: Int
        public var height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
}
