//
//  BallotExtensions.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/20/25.
//

import Foundation
import Balloting

extension RankedBallot {
    var isValid: Bool {
        let ranks = self.rankings.compactMap(\.rank)
        return ranks.count == Set(ranks).count
    }
}
