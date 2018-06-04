//
//  AnyDictionaryKey.swift
//  Peanut
//
//  Created by Shawn Throop on 30.05.18.
//

public protocol AnyDictionaryKey {
    
    init(keyValue: String)
    
    var keyValue: String { get }
}
