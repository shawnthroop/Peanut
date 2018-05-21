//
//  RawContainerDecodable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol RawContainerDecodable {
    init?(from container: RawContainerType)
}


extension RawContainerType {
    public func decode<T: RawContainerDecodable>(_ type: T.Type, forKey key: Raw.ContainerKey) -> T? {
        return nestedContainer(forKey: key).flatMap { T(from: $0) }
    }
    
    public func decode<T: RawContainerDecodable>(_ type: [T].Type, forKey key: Raw.ContainerKey) -> [T]? {
        return nestedContainers(forKey: key)?.compactMap { T(from: $0) }
    }
}

