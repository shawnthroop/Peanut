//
//  File.UploadParameters.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File {
    
    public struct UploadParameters: Hashable, Codable {
        public var method: APIMethod
        public var url: URL
        
        public init(method: APIMethod, url: URL) {
            self.method = method
            self.url = url
        }
    }
}
