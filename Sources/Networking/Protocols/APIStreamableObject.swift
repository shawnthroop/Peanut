//
//  APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIStreamableObject {
    associatedtype Stream: APIObjectRequestable
}
