//
//  RawContentKeyDecodable.swift
//  Peanut
//
//  Created by Shawn Throop on 28.05.18.
//

public protocol RawContentKeyDecodable {
    typealias Keys = Set<Identifier<RawContent>>
    
    static var validDecodableKeys: Keys { get }
}
