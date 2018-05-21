//
//  RawContainerType.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol RawContainerType {
    func decode(_ type: Bool.Type, forKey key: Raw.ContainerKey) -> Bool?
    func decode(_ type: Int.Type, forKey key: Raw.ContainerKey) -> Int?
    func decode(_ type: Double.Type, forKey key: Raw.ContainerKey) -> Double?
    func decode(_ type: String.Type, forKey key: Raw.ContainerKey) -> String?
    
    func decode(_ type: [Bool].Type, forKey key: Raw.ContainerKey) -> [Bool]?
    func decode(_ type: [Int].Type, forKey key: Raw.ContainerKey) -> [Int]?
    func decode(_ type: [Double].Type, forKey key: Raw.ContainerKey) -> [Double]?
    func decode(_ type: [String].Type, forKey key: Raw.ContainerKey) -> [String]?
    
    func nestedContainer(forKey key: Raw.ContainerKey) -> RawContainerType?
    func nestedContainers(forKey key: Raw.ContainerKey) -> [RawContainerType]?
}


extension RawContainerType {
    func decode(_ type: URL.Type, forKey key: Raw.ContainerKey) -> URL? {
        return decode(String.self, forKey: key).flatMap { URL(string: $0) }
    }
    
    func decode(_ type: [URL].Type, forKey key: Raw.ContainerKey) -> [URL]? {
        return decode([String].self, forKey: key)?.compactMap { URL(string: $0) }
    }
}
