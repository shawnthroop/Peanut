//
//  Content.Range.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Content {
    
    public struct Range: Hashable, Codable {
        public var position: Int
        public var length: Int
        
        public init(position: Int, length: Int) {
            self.position = position
            self.length = length
        }
    }
}


extension Content.Range {
    public var max: Int {
        return position + length
    }
}


extension Content.Range: SurrogatePairAdjustable {
    public func adjusted(for pairs: Set<String.SurrogatePair>) -> Content.Range {
        if pairs.isEmpty {
            return self
        }
        
        var adjusted = self
        
        for pair in pairs {
            if pair.index <= adjusted.max {
                if pair.index < adjusted.position {
                    adjusted.position += pair.offset
                } else {
                    adjusted.length += pair.offset
                }
            }
        }
        
        return adjusted
    }
}


private extension Content.Range {
    enum CodingKeys: String, CodingKey {
        case position   = "pos"
        case length     = "len"
    }
}

