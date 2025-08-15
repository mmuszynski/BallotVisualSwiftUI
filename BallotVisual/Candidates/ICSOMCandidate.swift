//
//  Candidate.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/24/25.
//

import Foundation
import Balloting

public struct ICSOMCandidate: Candidate {
    public var id: UUID
    public var name: String
    
    public init() {
        self.init(name: "New Candidate")
    }
    
    public init(name: String) {
        self.init(id: UUID(), name: name)
    }
    
    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension ICSOMCandidate: Comparable {
    public static func < (lhs: ICSOMCandidate, rhs: ICSOMCandidate) -> Bool {
        lhs.name < rhs.name
    }
}

extension ICSOMCandidate: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = ICSOMCandidate(name: value)
    }
}
