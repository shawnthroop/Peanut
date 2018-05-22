//
//  APIMutableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIMutableObject {
    associatedtype Mutation: APIObjectRequestable
}
