//
//  RawUnvalidatedContent.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

public typealias RawUnvalidatedContent = AnyDictionary<Identifier<RawContent>>

extension AnyDictionary {
    public func with(_ mutation: (inout AnyDictionary) -> Void) -> AnyDictionary {
        var mutable = self
        mutation(&mutable)
        
        return mutable
    }
}
