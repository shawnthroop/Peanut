//
//  RawEncodable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol RawEncodable {
    func encode(to container: inout KeyedEncodingContainer<Raw.ContainerKey>) throws
}
