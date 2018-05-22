//
//  Report.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

public enum Report: Hashable {
    case post(Post.ID, reason: Report.Reason)
    case message(Identifier<Message>, channel: Identifier<Channel>, reason: Report.Reason)
}
