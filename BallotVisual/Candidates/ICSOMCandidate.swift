//
//  Candidate.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/24/25.
//

import Foundation
import Balloting

public struct ICSOMCandidate: Candidate {
    public var id: UUID = UUID()
    public var name: String = "New Candidate"
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
