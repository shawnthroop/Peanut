//
//  RawDecodable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol RawDecodable {
    init?(from container: KeyedDecodingContainer<Raw.ContainerKey>) throws
}
