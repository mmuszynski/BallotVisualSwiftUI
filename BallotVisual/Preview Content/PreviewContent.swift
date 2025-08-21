//
//  PreviewContent.swift
//  BallotVisual
//
//  Created by Mike Muszynski on 6/9/25.
//

import Foundation
import Balloting

/*
 ==================================================================================================
 Elections with ICSOMCandidate Type and Int BallotID Type
 ==================================================================================================
 */

extension RankedBallot where C == ICSOMCandidate, BallotID == Int {
    static var example: RankedBallot {
        RankedBallot(id: 0, rankings: [RankedBallot.Ranking(candidate: "Bob", rank: 1)])
    }
}

extension RankedElection where C == ICSOMCandidate, BallotID == Int {
    static var example: RankedElection {
        let url = Bundle.main.url(forResource: "GoogleVotes", withExtension: "json")!
        do {
            var election = try JSONDecoder().decode(RankedElection.self, from: .init(contentsOf: url))
            election.ballots = election.ballots.sorted()
            return election
        } catch {
            fatalError("\(error)")
        }
    }
}

extension ElectionDocument where C == ICSOMCandidate, BallotID == Int {
    static var example: Self {
        .init(election: .init(ballots: RankedElection.example.ballots))
    }
}

extension IRVRound where C == ICSOMCandidate, BallotID == Int {
    static var example: Self {
        try! .init(election: .example, ignoring: [])
    }
}

/*
 ==================================================================================================
 Elections with ICSOMCandidate Type and UUID BallotID Type
 ==================================================================================================
 */

extension RankedBallot where C == ICSOMCandidate, BallotID == UUID {
    static var example: RankedBallot {
        RankedBallot(id: UUID(), rankings: [RankedBallot.Ranking(candidate: "Bob", rank: 1)])
    }
}

extension RankedElection where C == ICSOMCandidate, BallotID == UUID {
    static var example: RankedElection {
        RankedElection(ballots: [.example])
    }
}

extension ElectionDocument where C == ICSOMCandidate, BallotID == UUID {
    static var example: Self {
        .init(election: .init(ballots: RankedElection.example.ballots))
    }
}

extension IRVRound where C == ICSOMCandidate, BallotID == UUID {
    static var example: Self {
        try! .init(election: .example, ignoring: [])
    }
}
