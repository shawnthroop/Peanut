//
//  RawValueType.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol RawValueType: RawCodable {
    static var supportedKeys: Raw.ContainerKeys { get }
}
