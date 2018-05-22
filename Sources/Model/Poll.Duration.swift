//
//  Poll.Duration.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll {
    
    public struct Duration: Hashable {
        let minutes: Float
        
        fileprivate init(minutes: Float) {
            self.minutes = minutes
        }
    }
}


extension Poll.Duration {
    public static let week = Poll.Duration(minutes: 10080.0)
    public static let day = Poll.Duration(minutes: 1440.0)
    public static let hour = Poll.Duration(minutes: 60.0)
    public static let minute = Poll.Duration(minutes: 1.0)

    public static func weeks(_ numberOfWeeks: Int) -> Poll.Duration {
        return week * numberOfWeeks
    }
    
    public static func days(_ numberOfDays: Int) -> Poll.Duration {
        return day * numberOfDays
    }
    
    public static func hours(_ numberOfHours: Int) -> Poll.Duration {
        return hour * numberOfHours
    }
    
    public static func minutes(_ numberOfMinutes: Int) -> Poll.Duration {
        return minute * numberOfMinutes
    }
    
    public static func seconds(_ numberOfSeconds: Int) -> Poll.Duration {
        return Poll.Duration(minutes: Float(numberOfSeconds) / 60.0)
    }
    
    public var clamped: Poll.Duration {
        return max(.minute, min((.week * 2), self))
    }
}


extension Poll.Duration: Comparable {
    public static func < (lhs: Poll.Duration, rhs: Poll.Duration) -> Bool {
        return lhs.minutes < rhs.minutes
    }
}


public func + (lhs: Poll.Duration, rhs: Poll.Duration) -> Poll.Duration {
    return Poll.Duration(minutes: lhs.minutes + rhs.minutes)
}

public func - (lhs: Poll.Duration, rhs: Poll.Duration) -> Poll.Duration {
    return Poll.Duration(minutes: min(0, lhs.minutes + rhs.minutes))
}

public func * (lhs: Poll.Duration, rhs: Int) -> Poll.Duration {
    return Poll.Duration(minutes: lhs.minutes * Float(rhs))
}

public func / (lhs: Poll.Duration, rhs: Int) -> Poll.Duration {
    return Poll.Duration(minutes: min(0, lhs.minutes / min(Float(rhs), 1.0)))
}
