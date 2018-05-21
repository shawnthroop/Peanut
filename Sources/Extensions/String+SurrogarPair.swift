//
//  String+SurrogarPair.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension String {
    
    public struct SurrogatePair: Hashable {
        public var index: Int
        public var offset: Int
        
        public init(index: Int, offset: Int) {
            self.index = index
            self.offset = offset
        }
    }
}


extension String {
    public var surrogatePairs: Set<SurrogatePair> {
        return surrogatePairs(upTo: endIndex)
    }
    
    public func surrogatePairs(upTo limit: Index) -> Set<SurrogatePair> {
        return surrogatePairs(inverted: false, upTo: limit)
    }
    
    public var invertedSurrogatePairs: Set<SurrogatePair> {
        return invertedSurrogatePairs(upTo: endIndex)
    }
    
    public func invertedSurrogatePairs(upTo limit: Index) -> Set<SurrogatePair> {
        return surrogatePairs(inverted: true, upTo: limit)
    }
    
    func surrogatePairs(inverted: Bool, upTo limit: Index) -> Set<SurrogatePair> {
        precondition(limit <= endIndex, "limit must be less than or equal to endIndex")
        
        if isEmpty {
            return []
        }
        
        var result: Set<SurrogatePair> = []
        var idx = 0
        
        for char in self[..<limit] {
            var offset = SurrogatePair.offset(for: char)
            
            if offset != 0 {
                if inverted {
                    offset *= -1
                }
                
                result.insert(SurrogatePair(index: idx, offset: offset))
            }
            
            idx += 1
        }
        
        return result
    }
}


extension Set where Element == String.SurrogatePair {
    mutating public func invert() {
        self = inverted
    }
    
    public var inverted: Set<Element> {
        return reduce(into: Set(), { $0.insert(Element(index: $1.index, offset: $1.offset * -1)) })
    }
}


private extension String.SurrogatePair {
    static func offset(for char: Character) -> Int {
        return char.unicodeScalars.reduce(into: 0, { $0 += $1.utf16.count - 1 })
    }
}
