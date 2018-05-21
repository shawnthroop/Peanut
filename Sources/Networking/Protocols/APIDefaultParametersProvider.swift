//
//  APIDefaultParametersProvider.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol APIDefaultParametersProvider {
    
    /// Parameters to omit from each request because they are assumed.
    static var defaultParameters: APIParameters { get }
}
