//
//  Poll.Deadline.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll {
    
    public enum Deadline: Hashable {
        case duration(Duration)
        case date(Date)
    }
}
