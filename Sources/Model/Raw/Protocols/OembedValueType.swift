//
//  OembedValueType.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol OembedValueType: RawValueType {
    static var oembedType: String { get }
}


public extension OembedValueType {
    public var type: String {
        return Self.oembedType
    }
}
